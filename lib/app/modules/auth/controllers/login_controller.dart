import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/modules/home/views/main_view.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/dialog_manager.dart';
import 'package:localcooks_app/common/ui.dart';
import '';

import '../../../models/profile.dart';
import '../../../models/profile_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/dio_client.dart';
import '../../../services/background/local_storage_service.dart';
import '../services/auth_repo.dart';

class LoginController extends GetxController{

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  var isOTPCompleted = false.obs;
  RxBool isLoading = false.obs;
  RxBool isSessionValid = false.obs;
  final DioClient _httpClient = DioClient();
  LocalStorageService localStorageService = Get.find();
  final user = UserModel().obs;
  final profile = Profile().obs;

  var updateProfileForm = GlobalKey<FormState>();
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var formPhoneNumberController = TextEditingController();

  @override
  void onInit() {
    if(FirebaseAuth.instance.currentUser != null){
      isSessionValid.value = true;
      localStorageService.getUserFromStorage().then((onValue){
        if(onValue != null && onValue.token != null){
          user.value = onValue;
          user.refresh();
        }
      });
      localStorageService.getUserProfileFromStorage().then((onValue){
        if(onValue != null && onValue.userphone != null){
          profile.value = onValue;
          profile.refresh();
        }
      });
    }
    super.onInit();
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void login() async{
    if (phoneController.text.isNotEmpty) {
      isLoading.value = true;
      await AuthRepo.verifyPhoneNumber(phoneController.text);
      isLoading.value = false;
    } else {
      Ui.ErrorSnackBar(message: "Please enter valid Number").show();
    }
  }

  Future<void> verifyOTP(context) async{

    isLoading.value = true;
    var isVerified = await AuthRepo.submitOtp(otpController.text);
    isLoading.value = false;
    debugPrint("isVerified = $isVerified");
    if(isVerified){
      await getUserToken2();
    }

  }

  Future<void> getUserToken2() async{
    try {
      isLoading.value = true;
      var request = {
        'userphone': phoneController.text,
      };
      var response = await _httpClient.post(
        'controllers/login_api.php',
        data: request,
      );
      debugPrint("$response");
      isLoading.value = false;
      var fetchedUser = UserModel.fromJson(response);
      if(fetchedUser != null && fetchedUser.token != null){
        user.value = fetchedUser;
        await localStorageService.saveUserToStorage(fetchedUser);
        await getUserDetails(false);
        Get.back();
        callShops();
      }
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> getUserToken() async{
    try {
      isLoading.value = true;
      var request = {
        'userphone': phoneController.text,
      };
      var response = await _httpClient.post(
        'controllers/login_api.php',
        data: request,
      );
      debugPrint("$response");
      isLoading.value = false;
      var fetchedUser = UserModel.fromJson(response);
      if(fetchedUser != null && fetchedUser.token != null){
        user.value = fetchedUser;
        await localStorageService.saveUserToStorage(fetchedUser);
        await getUserDetails(false);
        callShops();
      }
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> getUserDetails(bool isFromHome) async{
    try {
      isLoading.value = true;
      var response = await _httpClient.get(
        'controllers/user_api.php',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${user.value.token}",
          }
        )
      );
      isLoading.value = false;
      var profileUser = ProfileModel.fromJson(response);
      if(profileUser != null && profileUser.data != null && profileUser.data!.isNotEmpty){
        debugPrint("before ${json.encode(profile.value)}");
        profile.value = profileUser.data![0];
        debugPrint("after ${json.encode(profile.value)}");
        await localStorageService.removeProfileFromStorage();
        await localStorageService.saveProfileToStorage(profile.value);
        isSessionValid.value = true;
        if(!isFromHome){
          HomeController homeController = Get.find();
          homeController.currentScreenIndex.value = 1;
          homeController.menuList.clear();
          homeController.menuList.addAll(homeController.getMenuItems());
          homeController.menuList.refresh();
          Future.delayed(const Duration(milliseconds: 800));
          homeController.currentScreen.value = MainView();
        }

        fullNameController.text = profile.value.username ?? "";
        emailController.text = profile.value.useremail ?? "";
        formPhoneNumberController.text = profile.value.userphone ?? "";

        profile.refresh();

        if(!isFromHome){
          if((profile.value.useremail == null || profile.value.useremail!.isEmpty) || (profile.value.username == null || profile.value.username!.isEmpty)){
            Future.delayed(const Duration(milliseconds: 800), (){
              Get.toNamed(Routes.UPDATE_PROFILE);
            });
          }
        }

      }
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> updateProfile() async{
    try {
      isLoading.value = true;
      var request = {
        "useremail" : emailController.text,
        "username" : fullNameController.text,
      };
      debugPrint(json.encode(request));
      var response = await _httpClient.put(
          'controllers/user_api.php',
          data: request,
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${user.value.token}",
              }
          )
      );
      debugPrint("$response");
      //await Future.delayed(const Duration(seconds: 5));
      await getUserDetails(true);
      isLoading.value = false;
      Get.back();
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> updateLocation(double lat, double lng, String address) async{
    try {
      isLoading.value = true;
      var request = {
        "latuser" : lat.toString(),
        "longuser" : lng.toString(),
        "useraddress" : address
      };
      debugPrint(json.encode(request));
      var response = await _httpClient.put(
          'controllers/user_api.php',
          data: request,
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${user.value.token}",
              }
          )
      );
      debugPrint("$response");
      HomeController homeController = Get.find();
      homeController.locationTextController.value.clear();
      await getUserDetails(true);
      isLoading.value = false;
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  void callShops() async{
    HomeController homeController = Get.find();
    await homeController.getShopsList();
  }

}
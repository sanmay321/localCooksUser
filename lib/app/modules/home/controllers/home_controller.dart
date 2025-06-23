import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localcooks_app/app/models/shops/shops.dart';
import 'package:localcooks_app/app/models/shops/shops_model.dart';
import 'package:localcooks_app/app/modules/auth/controllers/login_controller.dart';
import 'package:localcooks_app/app/modules/auth/services/auth_repo.dart';
import 'package:localcooks_app/app/modules/auth/views/login_screen.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/helper.dart';
import 'package:localcooks_app/common/ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/constants.dart';
import '../../../../common/dialog_manager.dart';
import '../../../models/drawer_item.dart';
import '../../../providers/dio_client.dart';
import '../services/location_service.dart';
import '../views/main_view.dart';

class HomeController extends GetxController with WidgetsBindingObserver{

  final advancedDrawerController = AdvancedDrawerController();
  RxBool isLoading = false.obs;
  var currentTabIndex = 0.obs;
  var currentScreenIndex = 1.obs;
  Rx<Widget> currentScreen = Rx<Widget>(Container(color: Colors.white,));
  final loginController = Get.put(LoginController());
  var menuList = <DrawerItem>[].obs;
  var locationTextController = TextEditingController().obs;
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;
  final DioClient _httpClient = DioClient();
  var shopList = <Shops>[].obs;
  var googleApikey = "AIzaSyCIkZnw63dKMSBMJZXgOvALPm0d2GrDUl8";
  var shopDetail = Shops().obs;

  @override
  void onInit() async{
    WidgetsBinding.instance.addObserver(this);
    await Future.delayed(const Duration(milliseconds: 500));
    menuList.addAll(getMenuItems());
    if(loginController.isSessionValid.value){
      currentScreenIndex.value = 1;
      currentScreen.value = MainView();
      isLoading.value = true;
      await loginController.getUserDetails(true);
      await getShopsList();
      isLoading.value = false;
    }else{
      menuList[menuList.length - 1].isSelected = true;
      menuList.refresh();
      currentScreenIndex.value = 4;
      currentScreen.value = LoginScreen();
    }
    super.onInit();
  }

  List<DrawerItem> getMenuItems(){
    return loginController.isSessionValid.value ? [
      DrawerItem(id: 1, title: 'Home', icon: Icons.home, isSelected: true),
      DrawerItem(id: 2, title: 'About Us', icon: Icons.info, isSelected: false),
      DrawerItem(id: 3, title: 'My Orders', icon: Icons.shopping_cart, isSelected: false),
      DrawerItem(id: 6, title: 'Privacy Policy', icon: Icons.settings, isSelected: false),
      DrawerItem(id: 7, title: 'Terms & Conditions', icon: Icons.notifications, isSelected: false),
      DrawerItem(id: 8, title: 'Customer Support', icon: Icons.feedback_outlined, isSelected: false),
      DrawerItem(id: 10, title: 'Deactivate Account', icon: Icons.cancel, isSelected: false),
      DrawerItem(id: 5, title: 'Logout', icon: Icons.logout, isSelected: false),
    ] : [
      DrawerItem(id: 2, title: 'About Us', icon: Icons.info, isSelected: false),
      DrawerItem(id: 6, title: 'Privacy Policy', icon: Icons.settings, isSelected: false),
      DrawerItem(id: 7, title: 'Terms & Conditions', icon: Icons.notifications, isSelected: false),
      DrawerItem(id: 8, title: 'Customer Support', icon: Icons.feedback_outlined, isSelected: false),
      DrawerItem(id: 4, title: 'Sign In', icon: Icons.login, isSelected: false)
    ];
  }

  Future<void> logout() async{
    isLoading.value = true;
    await AuthRepo.logoutApp();
    isLoading.value = false;
    loginController.isSessionValid.value = false;
    currentTabIndex.value = 0;
    currentScreenIndex.value = 4;
    currentScreen.value = LoginScreen();
    menuList.clear();
    menuList.addAll(getMenuItems());
    /*for(int i = 0; i<menuList.length;i++){
      menuList[i].isSelected = false;
    }
    menuList[0].isSelected = true;*/
    menuList[menuList.length - 1].isSelected = true;
    menuList.refresh();
  }

  void handleMenuButtonPressed() {
    Future.delayed(const Duration(milliseconds: 800));
    advancedDrawerController.toggleDrawer();
  }

  Future<void> fetchLocation() async {
    final position = await LocationService.getCurrentLocation();

    if (position == null) {
      final isPermanentlyDenied = await LocationService.isLocationPermanentlyDenied();
      debugPrint("isPermanentlyDenied = $isPermanentlyDenied");
      if (isPermanentlyDenied) {
        // Show a dialog explaining that they need to enable permissions in settings
        showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: Text('Location Permission Required'),
            content: Text(
              'This app needs location permissions to work properly. '
                  'Please enable them in the app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
        );
      } else {
        // Show a message that location is needed
        Ui.ErrorSnackBar(message: 'Location permission is required').show();
      }
    } else {
      // Use the location data
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      //print(place.street);
      selectedLatitude = position.latitude;
      selectedLongitude = position.longitude;
      locationTextController.value.text = place.street ?? "";
      locationTextController.refresh();
    }
  }

  Future<void> getShopsList() async{
    shopList.clear();
    isLoading.value = true;
    try {
      var response = await _httpClient.get(
          'controllers/shop_api.php?lid=$locationId',
      );
      var shopData = ShopsModel.fromJson(response);
      if(shopData != null && shopData.data != null && shopData.data!.isNotEmpty){
        shopList.addAll(shopData.data ?? []);
      }
      isLoading.value = false;
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> getShopsDetail(int shopId) async{
    shopList.clear();
    try {
      var response = await _httpClient.get(
          'controllers/shop_api.php/$shopId',
      );
      var status = response["status"];
      if(status != null && status == 200){
        var shopData = Shops.fromJson(response["data"]);
        if(shopData != null && shopData.status != null && shopData.accept_preorders != null){
          shopDetail.value = shopData;
        }
      }
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

}
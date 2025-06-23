import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/models/shops/addons_model.dart';
import 'package:localcooks_app/app/models/shops/product_categories.dart';
import 'package:localcooks_app/app/modules/shops/controllers/shop_details_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/event_actions.dart';
import 'package:localcooks_app/common/helper.dart';

import '../../../../common/dialog_manager.dart';
import '../../../providers/dio_client.dart';

class ProductDetailController extends GetxController{

  var addonsList = <AddonsData>[].obs;
  var product = Products().obs;
  var totalPrice = 0.0.obs;
  var addonPrice = 0.0.obs;
  var eventAddons = EventAction.NO_RECORD.obs;
  final DioClient _httpClient = DioClient();
  ShopDetailController shopDetailController = Get.find();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    product.value = Get.arguments;
    totalPrice.value = double.parse(product.value.price ?? "0.0");
    getAddons();
    super.onInit();
  }

  Future<void> getAddons() async{
    try {
      eventAddons.value = EventAction.LOADING;
      var response = await _httpClient.get(
        'controllers/addons_api.php',
        queryParameters: {
          "sid" : product.value.sid,
          "pid" : product.value.pid,
          "addon_group_id" : product.value.addonGroupId
        },
      );
      var addonsData = AddonsModel.fromJson(response);
      eventAddons.value = EventAction.FETCH;
      if(addonsData != null && addonsData.data != null && addonsData.data!.isNotEmpty){
        addonsList.addAll(addonsData.data ?? []);
        if(addonsList.isEmpty){
          eventAddons.value = EventAction.NO_RECORD;
        }
      }else{
        eventAddons.value = EventAction.NO_RECORD;
      }
    } on DioException catch (_) {
      eventAddons.value = EventAction.ERROR;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  ////https://localcook.shop/app/controllers/add_to_cart_api.php?sid=13&pid=117&addons=1078&lid=11

  var selectedAddonIds = <int>[].obs;

  Future<void> addToCart() async{

    var strAddons = selectedAddonIds.isNotEmpty ? selectedAddonIds.join(",") : "";
    debugPrint(strAddons);
    isLoading.value = true;

    try {
      var response = await _httpClient.get(
        'controllers/add_to_cart_api.php',
        queryParameters: {
          "sid" : product.value.sid,
          "lid" : 11,
          "addons" : ListParam<int>(selectedAddonIds, ListFormat.csv),
          "pid" : product.value.pid
        },
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${shopDetailController.homeController.loginController.user.value.token}",
              },
          )
      );
      isLoading.value = false;
      int status = response["status"];
      if(status == 200){
        isLoading.value = true;
        await shopDetailController.getCartCount(shopDetailController.shop.value.sid!);
        isLoading.value = false;
        Get.offNamed(Routes.CART);
      }
    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

}
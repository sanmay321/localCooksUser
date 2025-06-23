import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:localcooks_app/app/models/shops/cart.dart';
import 'package:localcooks_app/app/modules/shops/controllers/checkout_controller.dart';
import 'package:localcooks_app/app/modules/shops/controllers/confirm_delivery_address_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/constants.dart';
import 'package:localcooks_app/common/dialog_manager.dart';
import '../../../providers/dio_client.dart';

class OrderSummaryController extends GetxController{

  final DioClient _httpClient = DioClient();
  RxBool isLoading = false.obs;
  var tipList = <Tip>[].obs;
  RxBool isCustomTip = false.obs;
  RxDouble customTipAmount = 0.0.obs;
  RxDouble totalFinalAmount = 0.0.obs;
  ConfirmDeliveryAddressController confirmDeliveryAddressController = Get.find();

  @override
  void onInit() {
    tipList.addAll(Tip.getTipList());
    calculateTotal();
    super.onInit();
  }

  void subtractCustomTip(){
    if(customTipAmount.value == 1){
      return;
    }else{
      customTipAmount.value = customTipAmount.value - 1;
    }
    calculateTotal();
  }

  void addCustomTip(){
    if(customTipAmount.value == 100){
      return;
    }else{
      customTipAmount.value = customTipAmount.value + 1;
    }
    calculateTotal();
  }

  void calculateTotal(){
    totalFinalAmount.value = (confirmDeliveryAddressController.cartController.totalCartAmount.value + customTipAmount.value + 3.99 + (confirmDeliveryAddressController.cartController.totalCartAmount.value * (int.parse(confirmDeliveryAddressController.cartController.shopDetailController.shop.value.commission!) / 100)) );
    totalFinalAmount.refresh();
  }

  Future<void> createOrder() async{

    var listItems = <String>[];
    var addonItems = <CartItems2>[];
    for(var cartItem in confirmDeliveryAddressController.cartController.cartItemList){
      listItems.add("o${cartItem.pname} (x${cartItem.qty}) (\$${cartItem.price})");
      debugPrint(cartItem.pprice);
      addonItems.add(CartItems2(
        cartid: cartItem.cartid,
        pid: cartItem.pid,
        qty: cartItem.qty,
        product_price: double.parse(cartItem.pprice ?? "0.0"),
        pname: cartItem.pname,
        addonTotal: cartItem.addonTotal,
        addons: cartItem.addons,
        pimage: cartItem.pimage
      ));
    }

    var finalPname = listItems.join("<br>");

    var requestObj = {};
    if(confirmDeliveryAddressController.cartController.shopDetailController.deliveryOptionSwitch.value == 1){
      requestObj =  {
        "lid": "$locationId",
        "sid": "${confirmDeliveryAddressController.cartController.shopDetailController.shop.value.sid}",
        "userid": "${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.userid}",
        "did": 0,
        "uname": "${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.username}",
        "pname": finalPname,
        "price": totalFinalAmount.value.toStringAsFixed(4),
        "dcharge": "3.99",
        "shopcharge": confirmDeliveryAddressController.cartController.totalCartAmount.value.toStringAsFixed(2),
        "restrochargestatus": 0,
        "adminincome": (confirmDeliveryAddressController.cartController.totalCartAmount.value * (int.parse(confirmDeliveryAddressController.cartController.shopDetailController.shop.value.commission!) / 100)).toStringAsFixed(4),
        "rider": "",
        "status": "Order Placed",
        "tid": "1",
        "tax": (confirmDeliveryAddressController.cartController.totalCartAmount.value * (int.parse(confirmDeliveryAddressController.cartController.shopDetailController.shop.value.commission!) / 100)).toStringAsFixed(4),
        "temp": "85824",
        "orderAddress": "${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.useraddress}",
        "ordertime": DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.now()),//"07-04-2025 12:22:07am",
        "description": confirmDeliveryAddressController.instruction.value.text,
        "is_sms_sent": 0,
        "addons": json.encode(addonItems),
        "ready": 0,
        "tip": customTipAmount.value.toStringAsFixed(4)
      };
    }else{
      CheckoutController checkoutController = Get.find();
      var orderDay = checkoutController.dayDateMap[checkoutController.selectedDay.value];
      var orderTime = checkoutController.selectedHour.value;

      orderDay = DateFormat("yyyy-MM-dd").format(DateFormat("MMM dd, yyyy").parse(orderDay!));
      orderTime = DateFormat("HH:mm:ss").format(DateFormat("HH:mm").parse(orderTime));

      requestObj =  {
        "lid": "$locationId",
        "sid": "${confirmDeliveryAddressController.cartController.shopDetailController.shop.value.sid}",
        "userid": "${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.userid}",
        "did": 0,
        "uname": "${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.username}",
        "pname": finalPname,
        "price": totalFinalAmount.value.toStringAsFixed(4),
        "dcharge": "3.99",
        "shopcharge": confirmDeliveryAddressController.cartController.totalCartAmount.value.toStringAsFixed(2),
        "restrochargestatus": 0,
        "adminincome": (confirmDeliveryAddressController.cartController.totalCartAmount.value * (int.parse(confirmDeliveryAddressController.cartController.shopDetailController.shop.value.commission!) / 100)).toStringAsFixed(4),
        "rider": "",
        "status": "Order Placed",
        "tid": "1",
        "tax": (confirmDeliveryAddressController.cartController.totalCartAmount.value * (int.parse(confirmDeliveryAddressController.cartController.shopDetailController.shop.value.commission!) / 100)).toStringAsFixed(4),
        "temp": "85824",
        "orderAddress": "${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.useraddress}",
        "ordertime": DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.now()),//"07-04-2025 12:22:07am",
        "description": confirmDeliveryAddressController.instruction.value.text,
        "is_sms_sent": 0,
        "addons": json.encode(addonItems),
        "ready": 0,
        "tip": customTipAmount.value.toStringAsFixed(4),
        "preordertime":"$orderDay $orderTime",
      };
    }

    log(json.encode(requestObj));
    return;

    isLoading.value = true;
    
    try {
      var response = await _httpClient.post(
          'controllers/orders_api.php',
          data: requestObj,
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.user.value.token}",
              }
          )
      );
      isLoading.value = false;
      int status = response["status"];
      if(status == 200 || status == 201){
        isLoading.value = true;
        //confirmDeliveryAddressController.cartController.shopDetailController.getCartCount(confirmDeliveryAddressController.cartController.shopDetailController.shop.value.sid!);
        isLoading.value = false;
        //Get.offNamedUntil(Routes.ROOT, (Route<dynamic> predicate) => predicate.isFirst);
        clearCart();
      }

    } on DioException catch (_) {
      isLoading.value = false;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> clearCart() async{
    try {
      var response = await _httpClient.get(
          'controllers/cart_clear_api.php',
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.user.value.token}",
              }
          )
      );
      isLoading.value = false;
      int status = response["status"];
      if(status == 200 || status == 201){
        Get.offNamedUntil(Routes.ROOT, (Route<dynamic> predicate) => predicate.isFirst);
      }

    } on DioException catch (_) {
      DialogManager.showErrorDialogNoTitle(_.toString());
      isLoading.value = false;
    }
  }

}

class Tip{
  int id;
  String price;
  double? value;
  bool selected;

  Tip(this.id, this.price, this.value, this.selected);

  static List<Tip> getTipList(){
    var list = <Tip>[];
    list.add(Tip(1, "No Tip", 0.0, false));
    list.add(Tip(2, "10%", 10.0, false));
    list.add(Tip(3, "15%", 15.0, false));
    list.add(Tip(4, "20%", 20.0, false));
    return list;
  }
}
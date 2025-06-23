import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/modules/shops/controllers/shop_details_controller.dart';
import 'package:localcooks_app/common/event_actions.dart';

import '../../../../common/dialog_manager.dart';
import '../../../models/shops/cart.dart';
import '../../../providers/dio_client.dart';

class CartController extends GetxController{

  ShopDetailController shopDetailController = Get.find();
  final DioClient _httpClient = DioClient();
  var event = EventAction.NO_RECORD.obs;
  var cartItemList = <CartItems>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getCart();
    super.onInit();
  }

  Future<void> getCart() async{
    try {
      event.value = EventAction.LOADING;
      var response = await _httpClient.get(
        'controllers/cart_api.php',
        queryParameters: {
          "sid" : shopDetailController.shop.value.sid
        },
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${shopDetailController.homeController.loginController.user.value.token}",
              }
          )
      );
      var cartData = Cart.fromJson(response);
      event.value = EventAction.FETCH;
      if(cartData != null && cartData.data != null){
        cartItemList.addAll(cartData.data?.cartItems ?? []);
        if(cartItemList.isEmpty){
          event.value = EventAction.NO_RECORD;
        }
        calculateTotalCart();
      }else{
        event.value = EventAction.NO_RECORD;
      }
    } on DioException catch (_) {
      event.value = EventAction.ERROR;
    }
  }

  Future<void> updateProductQuantity(String cartId, int func, int cartItemIndex) async{
    var qty = int.parse(cartItemList[cartItemIndex].qty ?? "0");
    if(qty == 1 && func == 1){
      return;
    }
    try {
      var response = await _httpClient.get(
        'controllers/cart_update_quantity_api.php',
        queryParameters: {
          "cartid" : cartId,
          "func" : func,
        },
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${shopDetailController.homeController.loginController.user.value.token}",
              }
          )
      );

      int status = response["status"];
      if(status == 200){
        var quantity = int.parse(cartItemList[cartItemIndex].qty ?? "0");
        if(func == 2){
          quantity += 1;
        }else{
          quantity = quantity - 1;
        }
        cartItemList[cartItemIndex].qty = quantity.toString();
        cartItemList.refresh();
        calculateTotalCart();
      }

    } on DioException catch (_) {

    }
  }

  Future<void> removeCartItem(String cartId, int cartItemIndex) async{
    try {
      var response = await _httpClient.get(
        'controllers/cart_remove_item_api.php',
        queryParameters: {
          "cartid" : cartId
        },
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${shopDetailController.homeController.loginController.user.value.token}",
              }
          )
      );

      int status = response["status"];
      if(status == 200){
        cartItemList.removeAt(cartItemIndex);
        shopDetailController.getCartCount(shopDetailController.shop.value.sid!);
        if(cartItemList.isEmpty){
          event.value = EventAction.NO_RECORD;
        }
        calculateTotalCart();
      }

    } on DioException catch (_) {

    }
  }

  var totalCartAmount = 0.0.obs;

  void calculateTotalCart(){

    totalCartAmount.value = 0.0;

    for(var cartItem in cartItemList){
      var qty = int.parse(cartItem.qty ?? "0");
      var price = double.parse(cartItem.price ?? "0.0");
      totalCartAmount.value += qty * price;
      if(cartItem.addons != null && cartItem.addons!.isNotEmpty){
        for(var addon in cartItem.addons!){
          var amount = addon.price ?? 0.0;
          totalCartAmount.value += amount;
        }
      }
    }

  }

}
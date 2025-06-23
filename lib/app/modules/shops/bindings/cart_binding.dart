import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/shops/controllers/cart_controller.dart';

class CartBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(CartController());
  }

}
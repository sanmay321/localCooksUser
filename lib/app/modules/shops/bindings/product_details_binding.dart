import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/shops/controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ProductDetailController());
  }

}
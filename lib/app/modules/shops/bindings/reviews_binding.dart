import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/shops/controllers/reviews_controller.dart';

class ReviewBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ReviewsController());
  }

}
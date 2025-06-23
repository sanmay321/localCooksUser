import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/modules/home/controllers/my_order_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.lazyPut(() => MyOrderController());
  }

}
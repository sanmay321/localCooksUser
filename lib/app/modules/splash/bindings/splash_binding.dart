import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/splash/controllers/splash_controller.dart';

import '../../../services/fcm_service.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(SplashController());
  }

}
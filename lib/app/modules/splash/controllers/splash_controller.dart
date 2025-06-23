import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/auth/services/auth_repo.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus(){
    Future.delayed(const Duration(seconds: 3), (){
      Get.offNamed(Routes.ROOT);
    });
  }

}
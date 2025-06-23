import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/auth/controllers/login_controller.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
  }

}
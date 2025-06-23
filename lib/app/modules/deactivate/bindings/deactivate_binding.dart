import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/deactivate/controllers/deactivate_controller.dart';

class DeactivateBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(DeActivateAccountController());
  }

}
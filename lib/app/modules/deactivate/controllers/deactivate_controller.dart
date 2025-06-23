import 'package:get/get.dart';

import '../../../../common/dialog_manager.dart';
import '../../home/controllers/home_controller.dart';

class DeActivateAccountController extends GetxController{

  var selectedRadioTile = false.obs;
  var isSwitched = false.obs;
  HomeController homeController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  void callDeactivation() async{

  }

  void showDeactivationAlert(){
    DialogManager.showQuestionDialogOkCancel('deactivate_account'.tr, 'deactivate_account_message'.tr, (){
      Get.back();

    });
  }

}
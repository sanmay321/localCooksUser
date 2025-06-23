import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/shops/controllers/cart_controller.dart';
import 'package:localcooks_app/app/modules/shops/controllers/checkout_controller.dart';

class ConfirmDeliveryAddressController extends GetxController{

  CartController cartController = Get.find();
  var instruction = TextEditingController().obs;
  RxBool enableInstruction = false.obs;
  RxBool enableLocationEditing = false.obs;
  RxBool buttonEnabled = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    instruction.value.dispose();
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogManager{

  static void showSuccessDialogOk(String message, Function()? onOKClick){
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context){
          return CupertinoAlertDialog(
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: onOKClick,
                child: Text("ok".tr),
              )
            ],
          );
        }
    );
  }

  static void showErrorDialog(String title, String message){
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){Get.back();},
                child: Text("ok".tr),
              ),
            ],
          );
        }
    );
  }

  static void showErrorDialogNoTitle(String message){

    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context){
          return CupertinoAlertDialog(
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){Get.back();},
                child: Text("ok".tr),
              ),
            ],
          );
        }
    );
  }

  static void showErrorDialogNoTitleWithDelay(String message){

    Future.delayed(const Duration(microseconds: 800), (){
      showCupertinoModalPopup(
          context: Get.context!,
          builder: (context){
            return CupertinoAlertDialog(
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: (){Get.back();},
                  child: Text("ok".tr),
                ),
              ],
            );
          }
      );
    });
  }

  static void showErrorDialogOk(String title, String message, Function()? onOKClick){
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context){
          return CupertinoAlertDialog(
            //title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: onOKClick,
                child: Text("ok".tr),
              ),
            ],
          );
        }
    );
  }

  static void showUnAuthorized(Function()? onOKClick, {String? message}){
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context){
          return CupertinoAlertDialog(
            content: Text(message ?? 'auth_expired_error'.tr),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: onOKClick,
                child: Text("ok".tr),
              ),
            ],
          );
        }
    );
  }

  static showQuestionDialogOkCancel(String title, String message, Function() okClick){
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: okClick,
                child: Text("yes".tr),
              ),
              CupertinoDialogAction(
                child: Text("no".tr),
                onPressed: ()=>Get.back(),
              )
            ],
          );
        }
    );
  }

  static void showQuestionDialogYesNo(String title, String message, Function()? onOKClick, Function()? onCancelClick){
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context){
          return CupertinoAlertDialog(
            //title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: onOKClick,
                child: Text("yes".tr),
              ),
              CupertinoDialogAction(
                child: Text("no".tr),
                onPressed: onCancelClick,
              )
            ],
          );
        }
    );

  }

}
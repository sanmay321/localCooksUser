import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/auth/views/login_screen.dart';
import 'package:localcooks_app/app/modules/home/views/home_screen.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/dialog_manager.dart';
import 'package:localcooks_app/common/helper.dart';
import 'package:localcooks_app/common/ui.dart';

import '../views/otp_screen.dart';

class AuthRepo {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Future<void> verifyPhoneNumber(String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+1$number',
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(credential.verificationId!, credential.smsCode!);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          DialogManager.showErrorDialogNoTitleWithDelay('The provided phone number is not valid.');
        }else{
          DialogManager.showErrorDialogNoTitleWithDelay(e.toString());
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        Ui.SuccessSnackBar(title: "Login", message: "Code has been sent to your mobile number", snackPosition: SnackPosition.TOP);
        Get.toNamed(Routes.OTP);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<void> logoutApp() async {
    await _firebaseAuth.signOut();
  }

  static Future<bool> submitOtp(String otp) async{
    debugPrint("otp = $otp");
    return await signInWithPhoneNumber(verId, otp);
  }

  static Future<bool> signInWithPhoneNumber(String verificationId, String smsCode) async {
    debugPrint("verificationId = $verificationId");
    debugPrint("smsCode = $smsCode");
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      var userCredential = await _firebaseAuth.signInWithCredential(credential);
      if(userCredential.user != null){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
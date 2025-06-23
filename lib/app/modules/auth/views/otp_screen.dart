import 'package:artools/artools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../global_widgets/input_field_with_shadow.dart';
import '../../../global_widgets/loading_indicator.dart';
import '../../home/controllers/home_controller.dart';
import '../services/auth_repo.dart';

class OtpScreen extends StatelessWidget {

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/logo-white.png", height: 100, color: Theme.of(context).primaryColor,).animate()
                      .shimmer(duration: const Duration(seconds: 2),),
                  const Text(
                    'OTP',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Lobster'
                    ),
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms, delay: 100.ms)
                      .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: Get.width/1.5,
                    height: 40,
                    margin: EdgeInsets.only(top: 80),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.transparent,
                      autoDismissKeyboard: true,
                      enableActiveFill: true,
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        if(value.length == 6){
                          homeController.loginController.isOTPCompleted.value = true;
                        }else{
                          homeController.loginController.isOTPCompleted.value = false;
                        }
                      },
                      onCompleted: (value) {
                        homeController.loginController.isOTPCompleted.value = true;
                        homeController.loginController.otpController.text = value;
                      },
                      pinTheme: PinTheme(
                        fieldHeight: 40.00,
                        fieldWidth: 40.00,
                        shape: PinCodeFieldShape.box,
                        activeFillColor: Colors.grey.shade300,
                        inactiveFillColor: Colors.black12,
                        inactiveColor: Colors.transparent,
                        selectedColor: Colors.grey,
                        activeColor: Colors.red,
                      ),
                    ),
                  ),
                  /*InputFieldWithShadow(
                    textController: homeController.loginController.otpController,
                    hintLabel: "Enter Otp",
                    prefixIcon: MdiIcons.lockOutline,
                    isReadOnly: false,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),*/
                  const SizedBox(height: 25,),
                  CustomButton(
                    backgroundColor: homeController.loginController.isOTPCompleted.value ? Theme.of(context).primaryColor : Colors.grey.shade500,
                    onPressed: () {
                      homeController.loginController.verifyOTP(context);
                    },
                    buttonTitle: "Submit OTP",
                  ),
                ],
              ),
            ),
          ).isAbsorbing(homeController.loginController.isLoading.value),
          homeController.loginController.isLoading.value
              ? LoadingIndicator(
              isVisible: homeController.loginController.isLoading.value,
              loadingText: 'Verifying..')
              : const SizedBox.shrink()
        ],
      )),
    );
  }
}
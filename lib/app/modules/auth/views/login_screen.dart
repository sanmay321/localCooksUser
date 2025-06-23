import 'package:artools/artools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';

import '../../../global_widgets/input_field_with_shadow.dart';
import '../../../global_widgets/loading_indicator.dart';
import '../services/auth_repo.dart';

class LoginScreen extends StatelessWidget{

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //title: Text("Login", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: 'Lobster', color: Theme.of(context).primaryColor),),
        leading: IconButton(
          onPressed: homeController.handleMenuButtonPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: homeController.advancedDrawerController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : Icons.menu,
                  color: Theme.of(context).primaryColor,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() => Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20,),
                    Image.asset("assets/images/logo-white.png", height: 100, color: Theme.of(context).primaryColor,).animate()
                        .shimmer(duration: const Duration(seconds: 2),),
                    const Text(
                      'Login / SignUp',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Lobster'
                      ),
                    ).animate(delay: 500.ms).fadeIn(duration: 400.ms, delay: 100.ms)
                        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                    const SizedBox(
                      height: 40,
                    ),
                    InputFieldWithShadow(
                      textController: homeController.loginController.phoneController,
                      hintLabel: "Enter Phone Number",
                      prefixIcon: Icons.phone_android,
                      isReadOnly: false,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                    ).animate(delay: 500.ms).fadeIn(duration: 400.ms, delay: 300.ms)
                        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        homeController.loginController.login();
                      },
                      buttonTitle: "Send OTP",
                    ).animate(delay: 500.ms).fadeIn(duration: 400.ms, delay: 500.ms)
                        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ).isAbsorbing(homeController.loginController.isLoading.value),
            homeController.loginController.isLoading.value
                ? LoadingIndicator(
                isVisible: homeController.loginController.isLoading.value,
                loadingText: 'Logging In'.tr)
                : const SizedBox.shrink()
          ],
        )),
      ),
    );
  }
}

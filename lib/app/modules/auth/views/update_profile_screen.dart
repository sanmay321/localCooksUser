import 'package:artools/artools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/modules/auth/controllers/login_controller.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../global_widgets/input_field_with_shadow.dart';
import '../../../global_widgets/loading_indicator.dart';

class UpdateProfileScreen extends StatelessWidget {

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Form(
              key: homeController.loginController.updateProfileForm,
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  InputFieldWithShadow(
                    textController: homeController.loginController.fullNameController,
                    hintLabel: "Full Name",
                    prefixIcon: MdiIcons.accountCircleOutline,
                    isReadOnly: false,
                    keyboardType: TextInputType.text,
                    maxLength: 80,
                    validator: (val) => val == null || val!.isEmpty ? "Field required" : null,
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms, delay: 300.ms)
                      .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                  const SizedBox(height: 15,),
                  InputFieldWithShadow(
                    textController: homeController.loginController.formPhoneNumberController,
                    hintLabel: "Mobile Number",
                    prefixIcon: MdiIcons.cellphone,
                    isReadOnly: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 14,
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms, delay: 500.ms)
                      .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                  const SizedBox(height: 15,),
                  InputFieldWithShadow(
                    textController: homeController.loginController.emailController,
                    hintLabel: "Email",
                    prefixIcon: MdiIcons.emailOutline,
                    isReadOnly: false,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 80,
                    validator: (val) => val == null || val!.isEmpty ? "Field required" : null,
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms, delay: 700.ms)
                      .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                  const SizedBox(height: 25,),
                  CustomButton(onPressed: (){
                    if(homeController.loginController.updateProfileForm.currentState!.validate()){
                      homeController.loginController.updateProfile();
                    }
                  }, buttonTitle: "Update Profile", backgroundColor: Theme.of(context).primaryColor,)
                ],
              ),
            ),
          ).isAbsorbing(homeController.loginController.isLoading.value),
          homeController.loginController.isLoading.value
              ? LoadingIndicator(
              isVisible: homeController.loginController.isLoading.value,
              loadingText: 'Updating'.tr)
              : const SizedBox.shrink(),
        ],
      ))
    );
  }
}

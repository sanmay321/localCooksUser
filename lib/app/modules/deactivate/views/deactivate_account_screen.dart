import 'dart:convert';

import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_action/slide_action.dart';

import '../controllers/deactivate_controller.dart';

class DeActivateAccountScreen extends StatelessWidget {

  final controller = Get.put(DeActivateAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.homeController.handleMenuButtonPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: controller.homeController.advancedDrawerController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : MdiIcons.menu,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),
        title: Text('Deactivate Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Expanded(child: Text('If you wish to deactivate your volunteer account on the platform, click on “Deactivate Account” button. This will disable your account and hide your information.', textAlign: TextAlign.center,),),
            SlideAction(
              trackBuilder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                    /*boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                      ),
                    ],*/
                  ),
                  child: Center(
                    child: Text(
                      state.isPerformingAction
                          ? "Processing"
                          : "Slide to deactivate".tr,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
              thumbBuilder: (context, state) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    // Show loading indicator if async operation is being performed
                    child: state.isPerformingAction
                        ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    )
                        : const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              action: () async {
                // Async operation
                await Future.delayed(
                  const Duration(seconds: 1),
                      () => controller.showDeactivationAlert(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';

class ComingSoonScreen extends StatelessWidget {

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Local Cooks", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: 'Lobster', color: Theme.of(context).primaryColor),),
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
      body: Center(
          child: Text("Coming Soon")
      ),
    );
  }
}

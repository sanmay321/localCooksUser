import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/constants.dart';
import '../../../global_widgets/card_container.dart';

class ProfileScreen extends StatelessWidget {

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(MdiIcons.account, color: Theme.of(context).primaryColor,),
                const SizedBox(width: 5,),
                Expanded(child: Text("Personal Information", style: titleBold)),
                CustomButton(
                  width: 70,
                  height: 40,
                  icon: MdiIcons.pencil,
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: (){
                    Get.toNamed(Routes.UPDATE_PROFILE);
                  },
                  buttonTitle: "Update",
                )
              ],
            ),
            const SizedBox(height: 5,),
            Obx(() => CardContainer(
              sideColor: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Username:"),
                      const SizedBox(width: 10,),
                      Expanded(child: Text(homeController.loginController.profile.value.username ?? "-", style: titleNormalBold,)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text("Phone Number:"),
                      const SizedBox(width: 10,),
                      Expanded(child: Text(homeController.loginController.profile.value.userphone ?? "-", style: titleNormalBold,)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text("Email:"),
                      const SizedBox(width: 10,),
                      Expanded(child: Text(homeController.loginController.profile.value.useremail ?? "-", style: titleNormalBold,)),
                    ],
                  ),
                ],
              ),
            )),
            const SizedBox(height: 25,),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.orange,),
                const SizedBox(width: 5,),
                Expanded(child: Text("Delivery Address", style: titleBold)),
                CustomButton(
                  width: 70,
                    height: 40,
                    icon: MdiIcons.pencil,
                    backgroundColor: Colors.orange,
                    onPressed: (){
                      homeController.currentTabIndex.value = 1;
                      homeController.currentTabIndex.refresh();
                    },
                    buttonTitle: "Change",
                )
              ],
            ),
            const SizedBox(height: 5,),
            CardContainer(
              width: Get.width,
              sideColor: Colors.orange,
              child: Text(homeController.loginController.profile.value.useraddress ?? "-", style: titleNormalBold,),
            ),
          ],
        ),
      ),
    );
  }
}

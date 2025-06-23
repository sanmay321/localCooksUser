import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/coming_soon_screen.dart';
import 'package:localcooks_app/app/modules/deactivate/views/deactivate_account_screen.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/modules/privacy_policy_screen.dart';
import 'package:localcooks_app/app/modules/terms_conditions_screen.dart';

import '../../../../common/dialog_manager.dart';
import '../../auth/views/login_screen.dart';
import 'main_view.dart';

class HomeScreen extends StatelessWidget {

  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        controller: controller.advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 800),
        animateChildDecoration: true,
        //rtlOpening: Get.locale!.languageCode == "en" ? false : true,
        // openScale: 1.0,
        disabledGestures: true,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    const SizedBox(width: 10,),
                    Image.asset("assets/images/logo-white.png", height: 40, color: Theme.of(context).primaryColor,),
                    const SizedBox(width: 5,),
                    Text("Local Cooks", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: 'Lobster', color: Theme.of(context).primaryColor),),
                  ],
                ),
              ),
              const Divider(),
              //buildDrawerItem(controller, context)
              Expanded(
                child: Obx((){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.menuList.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: SizedBox(
                          height: 45,
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.menuList[index].isSelected ? Theme.of(context).primaryColor.withAlpha(20) : Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: (){
                                controller.currentScreenIndex.value = controller.menuList[index].id;
                                for(int i = 0; i<controller.menuList.length;i++){
                                  controller.menuList[i].isSelected = false;
                                }
                                controller.menuList[index].isSelected = true;
                                controller.menuList.refresh();
                                debugPrint("controller.currentScreenIndex.value => ${controller.currentScreenIndex.value}");
                                if(controller.currentScreenIndex.value == 1){
                                  controller.advancedDrawerController.hideDrawer();
                                  controller.currentTabIndex.value = 0;
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentScreen.value = MainView();
                                }else if(controller.currentScreenIndex.value == 2){
                                  controller.advancedDrawerController.toggleDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentScreen.value = ComingSoonScreen();
                                }else if(controller.currentScreenIndex.value == 3){
                                  controller.advancedDrawerController.hideDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentTabIndex.value = 2;
                                  controller.currentScreen.value = MainView();
                                }else if(controller.currentScreenIndex.value == 8){
                                  controller.advancedDrawerController.toggleDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentScreen.value = ComingSoonScreen();
                                }else if(controller.currentScreenIndex.value == 7){
                                  controller.advancedDrawerController.toggleDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentScreen.value = TermsConditionsScreen();
                                }else if(controller.currentScreenIndex.value == 6){
                                  controller.advancedDrawerController.toggleDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentScreen.value = PrivacyPolicyScreen();
                                }else if(controller.currentScreenIndex.value == 4){
                                  controller.advancedDrawerController.toggleDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentScreen.value = LoginScreen();
                                }else if(controller.currentScreenIndex.value == 10){
                                  controller.advancedDrawerController.toggleDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.currentScreen.value = DeActivateAccountScreen();
                                }else if(controller.currentScreenIndex.value == 5){
                                  controller.advancedDrawerController.toggleDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                  DialogManager.showQuestionDialogOkCancel('log_out'.tr, 'log_out_message'.tr, () async{
                                    Get.back();
                                    controller.logout();
                                  });
                                }else{
                                  controller.advancedDrawerController.hideDrawer();
                                  Future.delayed(const Duration(milliseconds: 800));
                                }
                              },
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Icon(controller.menuList[index].icon, color: controller.menuList[index].isSelected ? Theme.of(context).primaryColor : null,),
                                  const SizedBox(width: 10,),
                                  Expanded(child: Text(controller.menuList[index].title, style: TextStyle(color: controller.menuList[index].isSelected ? Theme.of(context).primaryColor : null,),)),
                                ],
                              ),
                            ),


                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        child: Obx((){
          return controller.currentScreen.value;
        }),
      ),
    );
  }

  Widget buildDrawerItem(HomeController homeController, BuildContext context) => Column(
    children: homeController.menuList.map((e) => ListTile(
      selectedColor: Colors.red.shade200,
      title: Text(e.title, ),
      leading: Icon(e.icon,),
      onTap: (){
        homeController.currentScreenIndex.value = e.id;
        if(homeController.currentScreenIndex.value == 1){
          homeController.advancedDrawerController.hideDrawer();
          homeController.currentScreen.value = MainView();
        }if(homeController.currentScreenIndex.value == 3){
          homeController.advancedDrawerController.hideDrawer();
          homeController.currentScreen.value = MainView();
          homeController.currentTabIndex.value = 2;
          homeController.currentTabIndex.refresh();
        }else if(homeController.currentScreenIndex.value == 2){
          homeController.advancedDrawerController.toggleDrawer();
          Future.delayed(const Duration(milliseconds: 800));
          homeController.currentScreen.value = ComingSoonScreen();
        }else if(homeController.currentScreenIndex.value == 8){
          homeController.advancedDrawerController.toggleDrawer();
          Future.delayed(const Duration(milliseconds: 800));
          homeController.currentScreen.value = ComingSoonScreen();
        }else if(homeController.currentScreenIndex.value == 4){
          homeController.advancedDrawerController.toggleDrawer();
          Future.delayed(const Duration(milliseconds: 800));
          homeController.currentScreen.value = LoginScreen();
        }else if(homeController.currentScreenIndex.value == 10){
          homeController.advancedDrawerController.toggleDrawer();
          Future.delayed(const Duration(milliseconds: 800));
          homeController.currentScreen.value = ComingSoonScreen();
        }else if(homeController.currentScreenIndex.value == 5){
          homeController.advancedDrawerController.toggleDrawer();
          Future.delayed(const Duration(milliseconds: 800));
          DialogManager.showQuestionDialogOkCancel('log_out'.tr, 'log_out_message'.tr, () async{
            Get.back();
            HomeController homeController = Get.find();
            homeController.currentTabIndex.value = 0;
            homeController.currentScreenIndex.value = 1;
            await homeController.logout();
          });
        }else{
          homeController.advancedDrawerController.hideDrawer();
          Future.delayed(const Duration(milliseconds: 800));
        }
      },
    )).toList(),
  );
}

/*body: Obx(() => Stack(
children: [
Container(
child: Center(child: Text(FirebaseAuth.instance.currentUser?.phoneNumber ?? "NO phone number"),),
).isAbsorbing(controller.isLoading.value),
controller.isLoading.value
? LoadingIndicator(
isVisible: controller.isLoading.value,
loadingText: 'Logout')
    : const SizedBox.shrink()
],
)),*/

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:localcooks_app/app/modules/auth/services/auth_repo.dart';
import 'package:localcooks_app/app/modules/auth/views/profile_screen.dart';
import 'package:localcooks_app/app/modules/home/views/home_view.dart';
import 'package:localcooks_app/app/modules/home/views/location_view.dart';
import 'package:localcooks_app/app/modules/home/views/order_view.dart';

import '../../auth/views/login_screen.dart';
import '../controllers/home_controller.dart';

class MainView extends StatelessWidget {

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
      body: Stack(
        children: [
          Obx((){
            return IndexedStack(
              index: homeController.currentTabIndex.value,
              children: allTabScreens(),
            );
          }),
          Align(alignment: Alignment.bottomCenter, child: Obx((){
            return Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Get.isDarkMode ? Colors.grey.shade200 : Colors.black.withOpacity(0.5), offset: const Offset(-2, 0), blurRadius: 20),
                    BoxShadow(color: Colors.red, offset: const Offset(0, 0), blurRadius: 0)]
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: GNav(
                    backgroundColor: Colors.transparent,
                    rippleColor: Colors.grey.shade800,
                    hoverColor: Colors.grey.shade700,
                    tabBorderRadius: 15,
                    tabActiveBorder: Border.all(color: Theme.of(context).primaryColor, width: 1), // tab button border
                    curve: Curves.easeOutExpo, // tab animation curves
                    duration: Duration(milliseconds: 400), // tab animation duration
                    gap: 8,
                    color: Get.isDarkMode ? Colors.white : Colors.black, // unselected icon color
                    activeColor: Theme.of(context).primaryColor, // selected icon and text color
                    iconSize: 20, // tab button icon size
                    tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1), // selected tab background color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
                    tabs: [
                      GButton(
                        icon: Icons.home,
                        //textStyle: TextStyle(fontSize: 12, color: Get.isDarkMode ? orange : navColorActive),
                        text: 'Home',
                      ),
                      GButton(
                        icon: Icons.map,
                        //textStyle: TextStyle(fontSize: 12, color: Get.isDarkMode ? orange : navColorActive),
                        text: 'Locations'.tr,
                      ),
                      GButton(
                        icon: Icons.lightbulb,
                        //textStyle: TextStyle(fontSize: 12, color: Get.isDarkMode ? orange : navColorActive),
                        text: 'Orders'.tr,
                      ),
                      GButton(
                        icon: Icons.account_circle,
                        //textStyle: TextStyle(fontSize: 12, color: Get.isDarkMode ? orange : navColorActive),
                        text: 'Profile'.tr,
                      ),
                      /*homeController.userController.isUserSessionExist.value && homeController.userController.appUser.value.data!.userPhoto != null && homeController.userController.appUser.value.data!.userPhoto!.isNotEmpty ? GButton(
                        leading: Obx((){
                          String imageString = homeController.userController.appUser.value.data!.userPhoto!;
                          Uint8List bytes = base64.decode(imageString.split(',').last);
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.memory(bytes, height: 25, width: 25, fit: BoxFit.cover,)
                          );
                        }),
                        icon: MdiIcons.account,
                        textStyle: TextStyle(fontSize: 12, color: Get.isDarkMode ? orange : navColorActive),
                        text: homeController.userController.appUser.value.data!.name!.length > 15 ? '${homeController.userController.appUser.value.data!.name!.substring(0, 5)}...' : homeController.userController.appUser.value.data!.name! ?? "profile".tr,
                      ) : GButton(
                        icon: MdiIcons.account,
                        textStyle: TextStyle(fontSize: 12, color: Get.isDarkMode ? orange : navColorActive),
                        text: 'profile'.tr,
                      )*/
                    ],
                    selectedIndex: homeController.currentTabIndex.value,
                    onTabChange: (index) {
                      homeController.locationTextController.value.clear();
                      homeController.locationTextController.refresh();
                      if(index != 3){
                        homeController.currentTabIndex.value = index;
                      }else{
                        if(homeController.loginController.isSessionValid.value){
                          homeController.currentTabIndex.value = 3;
                        }else{
                          homeController.currentScreenIndex.value = 4;
                          for(int i = 0; i<homeController.menuList.length;i++){
                            if(homeController.menuList[i].id == 4){
                              homeController.menuList[i].isSelected = true;
                            }else{
                              homeController.menuList[i].isSelected = false;
                            }
                          }
                          homeController.menuList.refresh();
                          Future.delayed(const Duration(milliseconds: 800));
                          homeController.currentScreen.value = LoginScreen();
                        }
                      }
                    },
                  ),
                ),
              ),
            );
          }),)
        ],
      ),
    );
  }

  List<Widget> allTabScreens(){
    return [
      HomeView(),
      LocationView(),
      OrderView(),
      ProfileScreen()
    ];
  }
}

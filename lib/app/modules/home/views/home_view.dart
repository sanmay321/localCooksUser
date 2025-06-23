import 'package:artools/artools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';

import '../../../../common/constants.dart';
import '../../../global_widgets/card_container.dart';
import '../../../global_widgets/loading_indicator.dart';

class HomeView extends StatelessWidget {

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async{
            await homeController.getShopsList();
          },
        child: Obx(() => Stack(
          children: [
            SizedBox(
                        width: Get.width,
                        height: Get.height,
                        child: SingleChildScrollView(
            primary: true,
            padding: EdgeInsets.all(15), child: Column(
            children: [
              CardContainer(
                  width: Get.width,
                  sideColor: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor,),
                          const SizedBox(width: 5,),
                          Expanded(child: Text("Delivery Address", style: titleBold)),
                        ],
                      ),
                      const Divider(),
                      Text(homeController.loginController.profile.value.useraddress ?? "-", style: titleNormalBold,),
                    ],
                  )
              ),
              const SizedBox(height: 10,),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: homeController.shopList.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.SHOP_DETAILS, arguments: homeController.shopList[index]);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: CardContainer(
                        sideColor: Theme.of(context).cardColor,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                                    placeholder: (context, s) => Center(child: const CircularProgressIndicator()),
                                    imageUrl: imageBaseURL + homeController.shopList[index].simage!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                        ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 30,
                                      margin: EdgeInsets.all(10),
                                      width: homeController.shopList[index].accept_preorders == 1 ? Get.width/2 : 100,
                                      decoration: BoxDecoration(
                                        color: homeController.shopList[index].accept_preorders == 1 ? Theme.of(context).primaryColor : Colors.grey.shade500,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                        child: Text(homeController.shopList[index].accept_preorders == 1 ? "PRE-ORDER AVAILABLE" : "CLOSED", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(width: 2, color: Colors.white)
                                      ),
                                      child: SizedBox(
                                        height: 80,
                                        child: CachedNetworkImage(
                                          errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                                          placeholder: (context, s) => Center(child: CupertinoActivityIndicator()),
                                          imageUrl: imageBaseURL + homeController.shopList[index].chefs_image!,
                                          imageBuilder: (context, imageProvider){
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(40),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: imageProvider
                                                  )
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //const SizedBox(height: 10,),
                            Padding(padding: EdgeInsets.all(15), child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(homeController.shopList[index].sname ?? "", style: titleBold,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("By ${homeController.shopList[index].sowner}"),
                                      Text(""),
                                      const SizedBox(width: 10,),
                                      Icon(Icons.star, color: Colors.amber, size: 17,),
                                      Text("${homeController.shopList[index].avgRating}", style: titleNormalBold,),
                                      Text(" (${homeController.shopList[index].totalReviews})", style: TextStyle(color: Colors.grey.shade500),),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 8.0, // horizontal spacing between chips
                                    runSpacing: 4.0, // vertical spacing between lines
                                    children: homeController.shopList[index].cuisines!.map((dta) => Chip(
                                      padding: EdgeInsets.all(4),
                                      label: Text(dta.CuName ?? ""),
                                      backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
                                      //deleteIcon: Icon(Icons.close, size: 18),
                                      //onDeleted: () {},
                                    )).toList(),
                                  )
                                ],
                              ),
                            ),)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50,)
            ],
                        ),),
                      ).isAbsorbing(homeController.loginController.isLoading.value),
            homeController.loginController.isLoading.value
                ? LoadingIndicator(
                isVisible: homeController.loginController.isLoading.value,
                loadingText: 'Loading'.tr)
                : const SizedBox.shrink(),
          ],
        )),
      ),
    );
  }
}

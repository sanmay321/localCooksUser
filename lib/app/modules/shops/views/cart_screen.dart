import 'package:artools/artools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/modules/shops/controllers/cart_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/dialog_manager.dart';
import 'package:localcooks_app/common/event_actions.dart';
import 'package:localcooks_app/common/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/constants.dart';
import '../../../global_widgets/card_container2.dart';
import '../../../global_widgets/loading_indicator.dart';

class CartScreen extends StatelessWidget {

  CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.shopDetailController.shop.value.sname ?? ""),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Obx(() => Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(child: Obx((){
                  if(controller.event.value == EventAction.FETCH){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.cartItemList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: CardContainer(
                            sideColor: Theme.of(context).cardColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CachedNetworkImage(
                                    errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                                    placeholder: (context, s) => Center(child: CupertinoActivityIndicator()),
                                    imageUrl: imageBaseURL + controller.cartItemList[index].pimage!,
                                    imageBuilder: (context, imageProvider){
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider
                                            )
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text(controller.cartItemList[index].pname ?? "", style: titleBold,)),
                                        GestureDetector(
                                            onTap: (){
                                              DialogManager.showQuestionDialogYesNo("Remove Item?",
                                                  "Are you sure you want to remove the item from your cart?",
                                                      (){
                                                    Get.back();
                                                    controller.removeCartItem(controller.cartItemList[index].cartid!, index);
                                                  },
                                                      (){
                                                    Get.back();
                                                  });
                                            },
                                            child: Icon(MdiIcons.closeCircle, color: Colors.grey.shade400, size: 20,)),
                                      ],
                                    ),
                                    Text("\$${controller.cartItemList[index].price}", style: titleNormalBold.copyWith(color: Theme.of(context).primaryColor),),
                                    const SizedBox(height: 5,),
                                    //controller.cartItemList[index].addons!.isNotEmpty ? const SizedBox(height: 5,) : const SizedBox.shrink(),
                                    controller.cartItemList[index].addons!.isNotEmpty ? Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: CardContainer2(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Add-ons", style: titleSmall,),
                                                const Spacer(),
                                                Text("\$${controller.cartItemList[index].addons!.fold(0.0, (sum, addon) => sum + addon.price!).toStringAsFixed(2)}", style: titleSmall.copyWith(color: Theme.of(context).primaryColor),),
                                              ],
                                            ),
                                            Wrap(
                                              children: controller.cartItemList[index].addons!.map((title) => Card(
                                                color: Colors.white,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: RichText(text: TextSpan(
                                                      style: TextStyle(fontSize: 12),
                                                      children: [
                                                        TextSpan(text: title.name ?? "", style: TextStyle(color: Colors.black)),
                                                        TextSpan(text: " (\$${title.price})", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                                                      ]
                                                  )),
                                                ),
                                              )).toList(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ) : const SizedBox.shrink(),
                                    controller.cartItemList[index].addons!.isNotEmpty ? const SizedBox(height: 10,) : const SizedBox.shrink(),
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      width: 75,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey.shade100
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              onTap: (){
                                                controller.updateProductQuantity(controller.cartItemList[index].cartid!, 2, index);
                                              },
                                              child: Icon(MdiIcons.plusCircle, color: Theme.of(context).primaryColor, size: 27,)),
                                          Expanded(child: Center(child: Text(controller.cartItemList[index].qty ?? "0", style: titleNormalBold,))),
                                          GestureDetector(
                                              onTap: (){
                                                controller.updateProductQuantity(controller.cartItemList[index].cartid!, 1, index);
                                              },
                                              child: Icon(MdiIcons.minusCircle, color: Theme.of(context).primaryColor, size: 27,)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }else if(controller.event.value == EventAction.LOADING){
                    return SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: Center(child: CircularProgressIndicator(),),
                    );
                  }else{
                    return SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: Center(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MdiIcons.cartOff, size: 50, color: Theme.of(context).primaryColor,),
                          Text("Empty Cart", style: titleBold,)
                        ],
                      ),),
                    );
                  }
                })),
                const SizedBox(height: 10,),
                Obx(() => CardContainer2(
                  sideColor: Colors.grey.shade100,
                  child: Column(
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Icon(MdiIcons.cart, color: Theme.of(context).primaryColor,),
                          Text("Cart Total", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                          const Spacer(),
                          Text("\$${controller.totalCartAmount.value.toStringAsFixed(2)}", style: titleBold.copyWith(color: Theme.of(context).primaryColor),)
                        ],
                      ),
                      const SizedBox(height: 10,),
                      CustomButton(onPressed: () async{
                        if(controller.cartItemList.isEmpty) return;
                        controller.isLoading.value = true;
                        await controller.shopDetailController.homeController.getShopsDetail(controller.shopDetailController.shop.value.sid!);
                        controller.isLoading.value = false;
                        if(controller.shopDetailController.homeController.shopDetail.value.status != null
                            && controller.shopDetailController.homeController.shopDetail.value.status == "1"
                            && controller.shopDetailController.homeController.shopDetail.value.accept_preorders == 1){
                          Get.toNamed(Routes.CHECKOUT);
                        }else if(controller.shopDetailController.homeController.shopDetail.value.status != null
                            && controller.shopDetailController.homeController.shopDetail.value.status == "0"
                            && controller.shopDetailController.homeController.shopDetail.value.accept_preorders == 1){
                          Get.toNamed(Routes.CHECKOUT);
                        }else if(controller.shopDetailController.homeController.shopDetail.value.status != null
                            && controller.shopDetailController.homeController.shopDetail.value.status == "1"
                            && controller.shopDetailController.homeController.shopDetail.value.accept_preorders == 0){
                          Get.offNamed(Routes.CONFIRM_DELIVERY_ADDRESS);
                        }else{
                          DialogManager.showErrorDialogNoTitle(shopClosed);
                        }
                      }, buttonTitle: "Proceed to Checkout", backgroundColor: controller.cartItemList.isEmpty ? Colors.grey : Theme.of(context).primaryColor,)
                    ],
                  ),
                )),
                const SizedBox(height: 10,),
              ],
            ),
          ).isAbsorbing(controller.isLoading.value),
          controller.isLoading.value
              ? LoadingIndicator(
              isVisible: controller.isLoading.value,
              loadingText: 'Loading'.tr)
              : const SizedBox.shrink(),
        ],
      )),
    );
  }
}

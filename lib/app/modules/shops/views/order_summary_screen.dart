import 'package:artools/artools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/dotted_separator.dart';
import 'package:localcooks_app/app/modules/shops/controllers/order_summary_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/constants.dart';
import '../../../../common/dialog_manager.dart';
import '../../../../common/ui.dart';
import '../../../global_widgets/card_container.dart';
import '../../../global_widgets/card_container2.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/loading_indicator.dart';
import '../../payment/views/payment_screen.dart';

class OrderSummaryScreen extends StatelessWidget {

  final controller = Get.put(OrderSummaryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
      ),
      body: Obx(() => Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 5,
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Icon(MdiIcons.mapMarkerOutline, color: Theme.of(context).primaryColor, size: 18,),
                                  const SizedBox(width: 5,),
                                  Text("Your order items (${controller.confirmDeliveryAddressController.cartController.cartItemList.length})", style: titleBold.copyWith(color: Colors.grey.shade600),)
                                ],
                              ),
                            ),
                            const Divider(),
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: controller.confirmDeliveryAddressController.cartController.cartItemList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: CachedNetworkImage(
                                          errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                                          placeholder: (context, s) => Center(child: CupertinoActivityIndicator()),
                                          imageUrl: imageBaseURL + controller.confirmDeliveryAddressController.cartController.cartItemList[index].pimage!,
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
                                              Expanded(child: Text(controller.confirmDeliveryAddressController.cartController.cartItemList[index].pname ?? "", style: titleBold,)),
                                            ],
                                          ),
                                          Text("\$${controller.confirmDeliveryAddressController.cartController.cartItemList[index].price} (x${controller.confirmDeliveryAddressController.cartController.cartItemList[index].qty})", style: titleNormalBold.copyWith(color: Theme.of(context).primaryColor),),
                                          const SizedBox(height: 5,),
                                          //controller.cartItemList[index].addons!.isNotEmpty ? const SizedBox(height: 5,) : const SizedBox.shrink(),
                                          controller.confirmDeliveryAddressController.cartController.cartItemList[index].addons!.isNotEmpty ? Padding(
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
                                                      Text("\$${controller.confirmDeliveryAddressController.cartController.cartItemList[index].addons!.fold(0.0, (sum, addon) => sum + addon.price!).toStringAsFixed(2)}", style: titleSmall.copyWith(color: Theme.of(context).primaryColor),),
                                                    ],
                                                  ),
                                                  Wrap(
                                                    children: controller.confirmDeliveryAddressController.cartController.cartItemList[index].addons!.map((title) => Card(
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
                                          controller.confirmDeliveryAddressController.cartController.cartItemList[index].addons!.isNotEmpty ? const SizedBox(height: 10,) : const SizedBox.shrink(),
                                        ],
                                      ))
                                    ],
                                  ),
                                );
                              }, separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                            ),
                            const Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CachedNetworkImage(
                                      errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                                      placeholder: (context, s) => Center(child: const CircularProgressIndicator()),
                                      imageUrl: imageBaseURL + controller.confirmDeliveryAddressController.cartController.shopDetailController.shop.value.chefs_image!,
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
                                  const SizedBox(width: 10,),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(controller.confirmDeliveryAddressController.cartController.shopDetailController.shop.value.sowner ?? "", style: titleBold,),
                                      Text("Chef at ${controller.confirmDeliveryAddressController.cartController.shopDetailController.shop.value.sname}", style: titleNormal.copyWith(height: 1.2),),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: DottedSeparator(color: Colors.grey.shade400,)),
                            Container(
                              width: Get.width,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Would you like to add a tip for your chef?", style: titleNormalBold,),
                                  Obx(() => SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.tipList.length,
                                      itemBuilder: (context, index){
                                        return GestureDetector(
                                          onTap: (){
                                            for(int i=0; i< controller.tipList.length; i++){
                                              controller.tipList[i].selected = false;
                                            }
                                            controller.customTipAmount.value = 0.0;
                                            controller.isCustomTip.value = false;
                                            controller.tipList[index].selected = true;
                                            controller.tipList.refresh();
                                            controller.isCustomTip.refresh();
                                            if(controller.tipList[index].selected && controller.tipList[index].id > 1){
                                              controller.customTipAmount.value = controller.confirmDeliveryAddressController.cartController.totalCartAmount.value * (controller.tipList[index].value! * 0.01);
                                              controller.customTipAmount.refresh();
                                            }
                                            controller.calculateTotal();
                                          },
                                          child: Container(
                                            width: Get.width/5.5,
                                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            padding: EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                                color: controller.tipList[index].selected ? Theme.of(context).primaryColor.withAlpha(30) : Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: controller.tipList[index].selected ? Theme.of(context).primaryColor : Colors.grey.shade500)
                                            ),
                                            child: Center(child: Text(controller.tipList[index].price),),
                                          ),
                                        );
                                      },
                                    ),
                                  )),
                                  const SizedBox(height: 5,),
                                  Obx(() => Column(
                                    children: [
                                      CustomButton(height: 35, onPressed: (){
                                        controller.customTipAmount.value = 1.0;
                                        for(int i=0; i< controller.tipList.length; i++){
                                          controller.tipList[i].selected = false;
                                        }

                                        controller.isCustomTip.value = true;
                                        controller.tipList.refresh();
                                        controller.calculateTotal();
                                      },
                                        buttonTitle: "Custom Tip",
                                        backgroundColor: controller.isCustomTip.value ? Theme.of(context).primaryColor : Colors.white,
                                        textColor: controller.isCustomTip.value ? Colors.white : Colors.black,
                                        borderColor: controller.isCustomTip.value ? Theme.of(context).primaryColor : Colors.transparent,
                                      ),
                                      controller.isCustomTip.value ? Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: Container(
                                        width: Get.width,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade400, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                controller.subtractCustomTip();
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                child: Icon(MdiIcons.minus, color: Theme.of(context).primaryColor,),
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            Text("\$${controller.customTipAmount.value.toStringAsFixed(2)}", style: titleLargeBold.copyWith(color: Theme.of(context).primaryColor),),
                                            const SizedBox(width: 20,),
                                            GestureDetector(
                                              onTap:(){
                                                controller.addCustomTip();
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                child: Icon(MdiIcons.plus, color: Theme.of(context).primaryColor,),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),) : const SizedBox.shrink(),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: DottedSeparator(color: Colors.grey.shade400,)),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Subtotal"),
                                    const SizedBox(width: 5,),
                                    Expanded(child: DottedSeparator(color: Colors.grey.shade300,)),
                                    const SizedBox(width: 5,),
                                    Text("\$${controller.confirmDeliveryAddressController.cartController.totalCartAmount.value.toStringAsFixed(2)}", style: titleNormalBold,),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text("Tax (${controller.confirmDeliveryAddressController.cartController.shopDetailController.shop.value.commission}%)"),
                                    const SizedBox(width: 5,),
                                    Expanded(child: DottedSeparator(color: Colors.grey.shade300,)),
                                    const SizedBox(width: 5,),
                                    Text("\$${(controller.confirmDeliveryAddressController.cartController.totalCartAmount.value * (int.parse(controller.confirmDeliveryAddressController.cartController.shopDetailController.shop.value.commission!) / 100)).toStringAsFixed(4)}", style: titleNormalBold,),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text("Delivery Fee"),
                                    const SizedBox(width: 5,),
                                    Expanded(child: DottedSeparator(color: Colors.grey.shade300,)),
                                    const SizedBox(width: 5,),
                                    Text("\$3.99", style: titleNormalBold,),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Obx((){
                                  if(controller.isCustomTip.value){
                                    return Row(
                                      children: [
                                        Text("Tip for Chef"),
                                        const SizedBox(width: 5,),
                                        Expanded(child: DottedSeparator(color: Colors.grey.shade300,)),
                                        const SizedBox(width: 5,),
                                        Text("\$${controller.customTipAmount.value.toStringAsFixed(2)}", style: titleNormalBold,),
                                      ],
                                    );
                                  }else{
                                    int idx = controller.tipList.indexWhere((val)=> val.selected == true);
                                    debugPrint("idx => $idx");
                                    if(idx >= 0){
                                      var tip = controller.tipList[idx];
                                      debugPrint("tip => ${tip.id}");
                                      if(tip.id == 1){
                                        return const SizedBox.shrink();
                                      }else{
                                        return Row(
                                          children: [
                                            Text("Tip for Chef"),
                                            const SizedBox(width: 5,),
                                            Expanded(child: DottedSeparator(color: Colors.grey.shade300,)),
                                            const SizedBox(width: 5,),
                                            Text("\$${controller.customTipAmount.value.toStringAsFixed(2)}", style: titleNormalBold,),
                                          ],
                                        );
                                      }
                                    }else{
                                      return const SizedBox.shrink();
                                    }

                                  }
                                }),
                                const SizedBox(height: 5,),
                                Divider(),
                                Obx(() {
                                    return Row(
                                      children: [
                                        Text("Total Amount", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                                        const SizedBox(width: 5,),
                                        Expanded(child: DottedSeparator(color: Theme.of(context).primaryColor,)),
                                        const SizedBox(width: 5,),
                                        Text("\$${controller.totalFinalAmount.value.toStringAsFixed(4)}", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                                      ],
                                    );
                                })
                              ],
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Card(
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(MdiIcons.informationOutline, color: Theme.of(context).primaryColor, size: 18,),
                                  const SizedBox(width: 5,),
                                  Text("Order Information", style: titleBold.copyWith(color: Colors.grey.shade600),)
                                ],
                              ),
                              const Divider(),
                              const SizedBox(height: 5,),
                              Text("Local Cook", style: titleNormalBold,),
                              Text(controller.confirmDeliveryAddressController.cartController.shopDetailController.shop.value.sname ?? "", style: titleNormalBold.copyWith(color: Colors.grey.shade600),),
                              const SizedBox(height: 5,),
                              Text("Your Name", style: titleNormalBold,),
                              Text(controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.username ?? "", style: titleNormalBold.copyWith(color: Colors.grey.shade600),),
                              const SizedBox(height: 5,),
                              Text("Phone Number", style: titleNormalBold,),
                              Text(controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.userphone ?? "", style: titleNormalBold.copyWith(color: Colors.grey.shade600),),
                              const SizedBox(height: 5,),
                              Text("Delivery Address", style: titleNormalBold,),
                              Text(controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.loginController.profile.value.useraddress ?? "", style: titleNormalBold.copyWith(color: Colors.grey.shade600, height: 1.2),),
                              const SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ),
              ),
              SafeArea(
                child: CardContainer2(
                  margin: EdgeInsets.zero,
                  sideColor: Colors.grey.shade100,
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      CustomButton(onPressed: () async{
                        controller.isLoading.value = true;
                        await controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.getShopsDetail(controller.confirmDeliveryAddressController.cartController.shopDetailController.shop.value.sid!);
                        controller.isLoading.value = false;

                        //controller.createOrder();

                        if((controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.shopDetail.value.status == "1"
                            && controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.shopDetail.value.accept_preorders == 1) ||
                            (controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.shopDetail.value.status == "0" && controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.shopDetail.value.accept_preorders == 1
                                && controller.confirmDeliveryAddressController.cartController.shopDetailController.deliveryOptionSwitch.value == 2) ||
                            (controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.shopDetail.value.status == "1"
                                && controller.confirmDeliveryAddressController.cartController.shopDetailController.homeController.shopDetail.value.accept_preorders == 0 && controller.confirmDeliveryAddressController.cartController.shopDetailController.deliveryOptionSwitch.value == 1)
                        ){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(amount: controller.totalFinalAmount.value),
                            ),
                          ).then((success) {
                            if (success == true) {
                              Ui.SuccessSnackBar(message: "Payment successful!").show();
                              controller.createOrder();
                            }else{
                              Ui.ErrorSnackBar(message: "Payment failed!").show();
                            }
                          });
                        }else{
                          DialogManager.showErrorDialogNoTitle(shopClosed);
                        }
                      },
                        icon: MdiIcons.creditCardOutline,
                        buttonTitle: "Proceed to Payment\t\t\t\t\t\t\t\t\t\t\t\t (\$${controller.totalFinalAmount.value.toStringAsFixed(4)})", backgroundColor: Theme.of(context).primaryColor,)
                    ],
                  ),
                ),
              ),
            ],
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

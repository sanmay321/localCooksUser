import 'package:artools/artools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/global_widgets/dotted_separator.dart';
import 'package:localcooks_app/app/modules/shops/controllers/product_detail_controller.dart';
import 'package:localcooks_app/common/event_actions.dart';
import 'package:localcooks_app/common/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/constants.dart';
import '../../../global_widgets/loading_indicator.dart';

class ProductDetailScreen extends StatelessWidget {

  ProductDetailController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          SizedBox(
            height: Get.height * 0.35,
            width: Get.width,
            child: CachedNetworkImage(
              errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
              placeholder: (context, s) => Center(child: CupertinoActivityIndicator()),
              imageUrl: imageBaseURL + controller.product.value.pimage!,
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
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: BackButton(color: Theme.of(context).primaryColor,),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: Get.height * 0.33), child: CardContainer(
            width: Get.width,
            sideColor: Theme.of(context).cardColor,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20,),
                        Text(controller.product.value.pname ?? "", style: titleLargeBold,),
                        Text("\$${controller.product.value.price}", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                        Text(controller.product.value.pdesc ?? "",),
                        const SizedBox(height: 10,),
                        Obx((){
                          if(controller.eventAddons.value == EventAction.FETCH){
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Customize your order", style: titleBold,),
                                  controller.addonsList.length > controller.product.value.maxAddons! ? Row(
                                    children: [
                                      Icon(MdiIcons.information, size: 15, color: Colors.black45,),
                                      const SizedBox(width: 3,),
                                      Text("Select upto ${controller.product.value.maxAddons} add-ons", style: titleMedium.copyWith(color: Colors.black87),),
                                    ],
                                  ) : const SizedBox.shrink(),
                                  const Divider(),
                                  ListView.builder(
                                    primary: false,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: controller.addonsList.length,
                                    itemBuilder: (context, index){
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300, width: 1),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            Checkbox(value: controller.addonsList[index].selected, onChanged: (val){
                                              var addonsSelected = controller.addonsList.where((addon) => addon.selected == true);
                                              var maxAddon = controller.product.value.maxAddons;
                                              if(addonsSelected.length == maxAddon){
                                                Ui.ErrorSnackBar(message: "You can select upto $maxAddon add-ons").show();
                                                return;
                                              }

                                              controller.addonsList[index].selected = !controller.addonsList[index].selected!;
                                              controller.addonsList.refresh();
                                              var actualPrice = double.parse(controller.product.value.price ?? "0.0");
                                              controller.totalPrice.value = 0;
                                              controller.addonPrice.value = 0;
                                              controller.selectedAddonIds.clear();
                                              addonsSelected.forEach((addon){
                                                var price = double.parse(addon.addonPrice ?? "0.0");
                                                controller.selectedAddonIds.add(addon.addonId!);
                                                controller.totalPrice.value += price;
                                                controller.addonPrice.value += price;
                                              });
                                              controller.totalPrice.value += actualPrice;
                                            }, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                                            Expanded(child: Text(controller.addonsList[index].addonName ?? "")),
                                            Text("\$${controller.addonsList[index].addonPrice}", style: titleNormalBold.copyWith(color: Theme.of(context).primaryColor),),
                                            const SizedBox(width: 5,),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300, width: 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Base price", style: titleNormal.copyWith(color: Colors.grey.shade600),),
                                            const Spacer(),
                                            Text("\$${controller.product.value.price}", style: titleNormal.copyWith(color: Colors.grey.shade600),),
                                          ],
                                        ),
                                        controller.addonPrice.value > 0 ? const SizedBox(height: 5,) : const SizedBox.shrink(),
                                        controller.addonPrice.value > 0 ? Row(
                                          children: [
                                            Text("Add-ons:", style: titleNormal.copyWith(color: Colors.grey.shade600),),
                                            const Spacer(),
                                            Text("\$${controller.addonPrice.value}", style: titleNormal.copyWith(color: Colors.grey.shade600),),
                                          ],
                                        ) : const SizedBox.shrink(),
                                        const SizedBox(height: 5,),
                                        DottedSeparator(color: Colors.grey,),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Text("Total:", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                                            const Spacer(),
                                            Text("\$${controller.totalPrice.value.toStringAsFixed(2)}", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }else if(controller.eventAddons.value == EventAction.LOADING){
                            return SizedBox(height: 100, child: Center(child: CupertinoActivityIndicator(),),);
                          }else{
                            return const SizedBox.shrink();
                          }
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                CustomButton(onPressed: (){
                  controller.addToCart();
                }, buttonTitle: "Add to Cart", backgroundColor: Theme.of(context).primaryColor,),
                const SizedBox(height: 10,),
              ],
            ),
          ),).isAbsorbing(controller.isLoading.value),
          controller.isLoading.value
              ? LoadingIndicator(
              isVisible: controller.isLoading.value,
              loadingText: 'Loading'.tr)
              : const SizedBox.shrink()
        ],
      )),
    );
  }
}

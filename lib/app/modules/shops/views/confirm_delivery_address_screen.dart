import 'package:artools/artools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:intl/intl.dart';
import 'package:localcooks_app/app/global_widgets/input_field_with_shadow.dart';
import 'package:localcooks_app/app/modules/shops/controllers/cart_controller.dart';
import 'package:localcooks_app/app/modules/shops/controllers/checkout_controller.dart';
import 'package:localcooks_app/app/modules/shops/controllers/confirm_delivery_address_controller.dart';
import 'package:localcooks_app/common/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/constants.dart';
import '../../../global_widgets/card_container2.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/loading_indicator.dart';
import '../../../routes/app_routes.dart';
import '../../payment/views/payment_screen.dart';

class ConfirmDeliveryAddressScreen extends StatelessWidget {

  final controller = Get.put(ConfirmDeliveryAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Delivery Address"),
      ),
      body: Obx(() => Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Card(
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor.withAlpha(40),
                                    radius: 17,
                                    child: Icon(MdiIcons.mapMarkerOutline, color: Theme.of(context).primaryColor, size: 18,),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text("Delivery Address", style: titleBold.copyWith(color: Colors.grey.shade600),)
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Theme.of(context).dividerColor.withAlpha(50),
                            ),
                            const SizedBox(height: 10,),
                            Obx(() => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                children: [
                                  Expanded(child: Text(controller.cartController.shopDetailController.homeController.loginController.profile.value.useraddress ?? "-", style: titleNormalBold.copyWith(fontWeight: FontWeight.w500),),),
                                  const SizedBox(width: 5,),
                                  ElevatedButton.icon(
                                    icon: Icon(MdiIcons.pencil, size: 15,),
                                    onPressed: (){
                                      controller.enableLocationEditing.value = !controller.enableLocationEditing.value;
                                      controller.enableInstruction.value = false;
                                      if(controller.enableInstruction.value){
                                        controller.buttonEnabled.value = false;
                                      }else{
                                        controller.buttonEnabled.value = true;
                                      }
                                    },
                                    label: Text("Edit"),
                                  )
                                ],
                              ),
                            ),),
                            Obx((){
                              if(controller.enableLocationEditing.value){
                                return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                    child: Column(
                                      children: [
                                        InputFieldWithShadow(
                                          textController: controller.cartController.shopDetailController.homeController.locationTextController.value,
                                          onTap: () async {
                                            var place = await PlacesAutocomplete.show(
                                              context: context,
                                              apiKey: controller.cartController.shopDetailController.homeController.googleApikey,
                                              mode: Mode.overlay,
                                              strictbounds: false,
                                              radius: 100000,
                                              cursorColor: Theme.of(context).primaryColor,
                                              //location: Location(lat: 53.4808, lng: -2.2426),
                                              //origin: Location(lat: 53.4808, lng: -2.2426),
                                              language: 'en',
                                              components: [Component(Component.country, 'ca')],
                                              types: [],
                                              onError: (err){
                                                print('============> $err');
                                              },
                                            );

                                            if(place != null){
                                              final plist = GoogleMapsPlaces(apiKey: controller.cartController.shopDetailController.homeController.googleApikey,
                                                apiHeaders: await const GoogleApiHeaders().getHeaders(),
                                              );
                                              String placeId = place.placeId ?? "0";
                                              final detail = await plist.getDetailsByPlaceId(placeId);
                                              var fullAddress = '${detail.result.name}, ${detail.result.formattedAddress}';
                                              controller.cartController.shopDetailController.homeController.locationTextController.value.text = fullAddress;
                                              controller.cartController.shopDetailController.homeController.locationTextController.refresh();
                                              final geometry = detail.result.geometry!;
                                              controller.cartController.shopDetailController.homeController.selectedLatitude = geometry.location.lat;
                                              controller.cartController.shopDetailController.homeController.selectedLongitude = geometry.location.lng;
                                            }else{
                                              debugPrint("place = null");
                                            }
                                          },
                                          hintLabel: "Enter your street address",
                                          prefixIcon: Icons.location_on_outlined,
                                          isReadOnly: true,
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            Expanded(child: CustomButton(onPressed: (){
                                              controller.enableLocationEditing.value = false;
                                              controller.cartController.shopDetailController.homeController.locationTextController.value.clear();
                                            }, buttonTitle: "Cancel", backgroundColor: Colors.grey.shade300, height: 35, textColor: Colors.black, icon: MdiIcons.close,)),
                                            const SizedBox(width: 10,),
                                            Expanded(child: CustomButton(onPressed: () async{
                                              if(controller.cartController.shopDetailController.homeController.locationTextController.value.text.isEmpty){
                                                Ui.ErrorSnackBar(message: "Please select the location to update").show();
                                                return;
                                              }
                                              controller.enableLocationEditing.value = false;
                                              controller.instruction.refresh();
                                              controller.isLoading.value = true;
                                              await controller.cartController.shopDetailController.homeController.loginController.updateLocation(controller.cartController.shopDetailController.homeController.selectedLatitude, controller.cartController.shopDetailController.homeController.selectedLongitude, controller.cartController.shopDetailController.homeController.locationTextController.value.text);
                                              controller.isLoading.value = false;
                                            }, buttonTitle: "Update", backgroundColor: Theme.of(context).primaryColor, height: 35, icon: MdiIcons.check,)),
                                          ],
                                        ),
                                      ],
                                    )
                                );
                              }else{
                                return const SizedBox.shrink();
                              }
                            }),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Color(0xFFfe8700).withAlpha(10),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(MdiIcons.informationOutline, color: Colors.orange, size: 17,),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Text("Your order will be delivered to this address, Make sure it's accurate for timely delivery", style: titleMedium,)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Card(
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor.withAlpha(40),
                                    radius: 17,
                                    child: Icon(MdiIcons.fileDocumentOutline, color: Theme.of(context).primaryColor, size: 18,),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text("Delivery Instruction", style: titleBold.copyWith(color: Colors.grey.shade600),)
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Theme.of(context).dividerColor.withAlpha(50),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                children: [
                                  Expanded(child: Obx(() => Text(controller.instruction.value.text.isEmpty ? "No Special Instruction" : controller.instruction.value.text, style: titleNormalBold.copyWith(fontWeight: FontWeight.w500, color: controller.instruction.value.text.isEmpty ? Colors.grey : Colors.black),),)),
                                  const SizedBox(width: 5,),
                                  ElevatedButton.icon(
                                    icon: Icon(MdiIcons.pencil, size: 15,),
                                    onPressed: (){
                                      controller.enableInstruction.value = !controller.enableInstruction.value;
                                      controller.enableLocationEditing.value = false;
                                      if(controller.enableInstruction.value){
                                        controller.buttonEnabled.value = false;
                                      }else{
                                        controller.buttonEnabled.value = true;
                                      }
                                    },
                                    label: Text("Edit"),
                                  ),
                                ],
                              ),
                            ),
                            Obx((){
                              if(controller.enableInstruction.value){
                                return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                    child: Column(
                                      children: [
                                        InputFieldWithShadow(
                                          hintLabel: 'Enter special instruction for delivery (Optional)',
                                          prefixIcon: MdiIcons.textBoxOutline,
                                          textController: controller.instruction.value,
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            Expanded(child: CustomButton(onPressed: (){
                                              controller.enableInstruction.value = false;
                                              controller.buttonEnabled.value = true;
                                            }, buttonTitle: "Cancel", backgroundColor: Colors.grey.shade300, height: 35, textColor: Colors.black, icon: MdiIcons.close,)),
                                            const SizedBox(width: 10,),
                                            Expanded(child: CustomButton(onPressed: (){
                                              controller.enableInstruction.value = false;
                                              controller.instruction.refresh();
                                              controller.buttonEnabled.value = true;
                                            }, buttonTitle: "Update", backgroundColor: Theme.of(context).primaryColor, height: 35, icon: MdiIcons.check,)),
                                          ],
                                        ),
                                      ],
                                    )
                                );
                              }else{
                                return const SizedBox.shrink();
                              }
                            }),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Color(0xFFfe8700).withAlpha(10),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(MdiIcons.informationOutline, color: Colors.orange, size: 17,),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Text("Add any specific instruction for the delivery driver\n(gate codes, landmark details etc.)", style: titleMedium,)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Card(
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor.withAlpha(40),
                                    radius: 17,
                                    child: Icon(MdiIcons.clockTimeFiveOutline, color: Theme.of(context).primaryColor, size: 18,),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text("Delivery Time", style: titleBold.copyWith(color: Colors.grey.shade600),)
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Theme.of(context).dividerColor.withAlpha(50),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Obx((){
                                if(controller.cartController.shopDetailController.deliveryOptionSwitch.value == 1){
                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColor.withAlpha(30),
                                        radius: 17,
                                        child: Icon(MdiIcons.flashOutline, color: Theme.of(context).primaryColor,),
                                      ),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("ASAP Delivery", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                                            Text("Your order will be prepared and delivered as soon as possible", style: titleNormal.copyWith(height: 1.2),),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }else{
                                  CheckoutController checkoutController = Get.find();
                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColor.withAlpha(30),
                                        radius: 17,
                                        child: Icon(MdiIcons.calendar, color: Theme.of(context).primaryColor,),
                                      ),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${checkoutController.selectedDay.value} ${checkoutController.dayDateMap[checkoutController.selectedDay.value]}", style: titleNormal.copyWith(height: 1.2),),
                                            Text(DateFormat("hh:mm a").format(DateFormat("HH:mm").parse(checkoutController.selectedHour.value)), style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                                            Text("Your order will be prepared and delivered at the scheduled time", style: titleNormal.copyWith(height: 1.2),),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }
                              }),
                            ),
                            const SizedBox(height: 10,),
                            controller.cartController.shopDetailController.deliveryOptionSwitch.value == 1 ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Color(0xFFfe8700).withAlpha(10),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(MdiIcons.informationOutline, color: Colors.orange, size: 17,),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Text("We deliver to St. John's and some surrounding areas.", style: titleMedium,)),
                                  ],
                                ),
                              ),
                            ) : const SizedBox.shrink(),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                )),
                Obx(() => SafeArea(
                  child: CardContainer2(
                    margin: EdgeInsets.zero,
                    sideColor: Colors.grey.shade100,
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Icon(MdiIcons.cart, color: Theme.of(context).primaryColor,),
                            Text("Cart Total", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                            const Spacer(),
                            Text("\$${controller.cartController.totalCartAmount.value.toStringAsFixed(2)}", style: titleBold.copyWith(color: Theme.of(context).primaryColor),)
                          ],
                        ),
                        const SizedBox(height: 10,),
                        CustomButton(onPressed: (){
                          if(!controller.buttonEnabled.value) return;
                          Get.toNamed(Routes.ORDER_SUMMARY);
                          // Navigate to payment screen
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(amount: controller.cartController.totalCartAmount.value),
                            ),
                          ).then((success) {
                            if (success == true) {
                              Ui.SuccessSnackBar(message: "Payment successful!").show();
                            }else{
                              Ui.ErrorSnackBar(message: "Payment failed!").show();
                            }
                          });*/
                        }, buttonTitle: "Confirm & Proceed", backgroundColor: !controller.buttonEnabled.value ? Colors.grey : Theme.of(context).primaryColor,)
                      ],
                    ),
                  ),
                )),
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

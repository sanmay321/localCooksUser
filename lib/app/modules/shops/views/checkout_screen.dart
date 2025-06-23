import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/modules/shops/controllers/checkout_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CheckoutScreen extends StatelessWidget {

  final controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(controller.shopDetailController.shop.value.sname ?? ""),
      ),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                !controller.isOnlyPreOrder.value ? const SizedBox.shrink() : Card(
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
                            Text("Delivery Options", style: titleBold.copyWith(color: Colors.grey.shade600),)
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
                        child: Obx(() => Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  controller.shopDetailController.deliveryOptionSwitch.value = 1;
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller.shopDetailController.deliveryOptionSwitch.value == 1 ? Theme.of(context).primaryColor.withAlpha(30) : Colors.transparent,
                                    border: Border.all(color: controller.shopDetailController.deliveryOptionSwitch.value == 1 ? Theme.of(context).primaryColor : Colors.grey.shade500 ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(MdiIcons.flashOutline, color: controller.shopDetailController.deliveryOptionSwitch.value == 1 ? Theme.of(context).primaryColor : Colors.grey.shade700),
                                      Text("Order Now", style: titleBold.copyWith(color: controller.shopDetailController.deliveryOptionSwitch.value == 1 ? Theme.of(context).primaryColor : Colors.black),),
                                      Text("Delivered ASAP", style: titleNormal,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  controller.shopDetailController.deliveryOptionSwitch.value = 2;
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller.shopDetailController.deliveryOptionSwitch.value == 2 ? Theme.of(context).primaryColor.withAlpha(30) : Colors.transparent,
                                    border: Border.all(color: controller.shopDetailController.deliveryOptionSwitch.value == 2 ? Theme.of(context).primaryColor : Colors.grey.shade500 ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(MdiIcons.calendar, color: controller.shopDetailController.deliveryOptionSwitch.value == 2 ? Theme.of(context).primaryColor : Colors.grey.shade700),
                                      Text("Schedule", style: titleBold.copyWith(color: controller.shopDetailController.deliveryOptionSwitch.value == 2 ? Theme.of(context).primaryColor : Colors.black),),
                                      Text("Select date & time", style: titleNormal,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ),
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
                              Expanded(child: Text("Order placed for now will be prepared and delivered as soon as possible, alternatively you can schedule your order for a later date and time", style: titleMedium,)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                !controller.isOnlyPreOrder.value ? const SizedBox.shrink() : const SizedBox(height: 10,),
                Card(
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10                                                                                                                           ),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor.withAlpha(40),
                                    radius: 17,
                                    child: Icon(MdiIcons.calendar, color: Theme.of(context).primaryColor, size: 18,),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text("Schedule for later", style: titleBold.copyWith(color: Colors.grey.shade600),)
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Theme.of(context).dividerColor.withAlpha(50),
                            ),
                            const SizedBox(height: 10,),
                            Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 60, // Increased height to accommodate date
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.openDays.length,
                                    itemBuilder: (context, index) {
                                      final day = controller.openDays[index];
                                      final isSelected = controller.selectedDay == day['day'];

                                      return GestureDetector(
                                        onTap: () => controller.selectDay(day['day']),
                                        child: Container(
                                          width: 90,
                                          margin: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                              color: isSelected ? Theme.of(context).primaryColor.withAlpha(30) : Colors.grey[200],
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade500)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                day['day'],
                                                style: titleBold,
                                              ),
                                              Text(
                                                day['formatted_date'],
                                                style: titleMedium,
                                              ),
                                              /*if (day['is_today'])
                                            Text(
                                              'Today',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),*/
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (controller.selectedDay.value != null) ...[
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                    child: Text(
                                      'Available hours for ${controller.selectedDay.value}:',
                                      //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      style: titleNormalBold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        for (var hour in controller.selectedDayHours)
                                          GestureDetector(
                                            onTap: () => controller.selectHour(hour),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: controller.selectedHour.value == hour ? Theme.of(context).primaryColor.withAlpha(30) : Colors.transparent,
                                                borderRadius: BorderRadius.circular(10),
                                                border: controller.selectedHour.value == hour
                                                    ? Border.all(color: Theme.of(context).primaryColor, width: 1)
                                                    : Border.all(color: Colors.grey.shade500, width: 1),
                                              ),
                                              child: Text(
                                                DateFormat("hh:mm a").format(DateFormat("HH:mm").parse(hour)),
                                                style: titleNormal,
                                                /*style: TextStyle(
                                              fontSize: 16,
                                              color: controller.selectedHour.value == hour ? Colors.white : Colors.black,
                                            ),*/
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  if (controller.selectedHour.isNotEmpty)
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.green),
                                          SizedBox(width: 8),
                                          Text(
                                            'Selected: ${controller.selectedDay.value} ${controller.dayDateMap[controller.selectedDay.value]} at ${DateFormat("hh:mm a").format(DateFormat("HH:mm").parse(controller.selectedHour.value))}',
                                            style: titleMediumBold,
                                          ),
                                        ],
                                      ),
                                    ),
                                ]
                              ],
                            )),
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
                                    Expanded(child: Text("All time shown are in Newfoundland Timezone (GMT-3:30)", style: titleMedium,)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                        Obx((){
                          if(controller.shopDetailController.deliveryOptionSwitch.value == 1){
                            return Positioned.fill(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                child: Container(color: Colors.transparent),
                              ),
                            );
                          }else{
                            return const SizedBox.shrink();
                          }
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            color: Theme.of(context).cardColor,
            child: Obx(() => CustomButton(
              backgroundColor: controller.shopDetailController.deliveryOptionSwitch.value == 1 ? Theme.of(context).primaryColor : controller.selectedHour.value.isEmpty ? Colors.grey : Theme.of(context).primaryColor,
              onPressed: (){
                if(controller.selectedHour.value.isEmpty && controller.shopDetailController.deliveryOptionSwitch.value == 2) return;
                Get.toNamed(Routes.CONFIRM_DELIVERY_ADDRESS);
              },
              buttonTitle: controller.shopDetailController.deliveryOptionSwitch.value == 1 ? "Continue with ASAP Delivery" : controller.selectedHour.value.isEmpty ? "Please select a date and time" : "Schedule for selected time"),)
          ),
        ],
      ),
    );
  }
}

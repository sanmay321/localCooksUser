import 'dart:convert';
import 'dart:developer';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/global_widgets/card_container2.dart';
import 'package:localcooks_app/app/global_widgets/dotted_separator.dart';
import 'package:localcooks_app/app/models/shops/cart.dart';
import 'package:localcooks_app/app/modules/home/controllers/my_order_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/constants.dart';
import 'package:localcooks_app/common/event_actions.dart';
import 'package:localcooks_app/common/order_type.dart';
import 'package:localcooks_app/main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderView extends StatelessWidget {
  final controller = Get.put(MyOrderController());

  OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(child: Obx(() {
        if (controller.event.value == EventAction.LOADING) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.event.value == EventAction.FETCH) {
          return ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 80),
            itemCount: controller.ordersList.length,
            itemBuilder: (context, index) {
              var order = controller.ordersList[index];
              var productName = order.pname ?? "";
              productName = productName
                  .replaceAll(RegExp(r'<br>$'), '') // Remove last <br>
                  .replaceAll('<br>', '\n') // Replace other <br> with \n
                  .replaceAllMapped(
                      RegExp(r'^o|(\n)o'), (match) => match.group(1) ?? '');

              var addonsList = <CartItems2>[];
              if (order.addons != null && order.addons!.isNotEmpty) {
                List<dynamic> data = jsonDecode(order.addons!);
                if (data.isNotEmpty) {
                  for (var addon in data) {
                    addonsList.add(CartItems2.fromJson(addon));
                  }
                }
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Order Details screen
                    if (order.oid != null) {
                      Get.toNamed(Routes.ORDER_DETAILS,
                          parameters: {'id': order.oid.toString()});
                    }
                  },
                  child: CardContainer(
                    sideColor: order.oid != null
                        ? Theme.of(context).primaryColor
                        : Color(0xFFe67800),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Order #${order.oid ?? order.preoid}",
                              style: titleNormalBold.copyWith(
                                  color: order.oid == null
                                      ? Color(0xFFe67800)
                                      : Theme.of(context).primaryColor),
                            ),
                            order.oid == null
                                ? Container(
                                    margin: EdgeInsets.only(left: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFe67800),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          MdiIcons.clockTimeFiveOutline,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "PRE-ORDER",
                                          style: titleSmall.copyWith(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                DateFormat("MMM dd, hh:mm a").format(
                                    DateFormat("dd-MM-yyyy hh:mm:ss a").parse(
                                        order.ordertime!
                                            .replaceAll("am", " AM")
                                            .replaceAll("pm", " PM"))),
                                style: titleSmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedSeparator(),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productName),
                                    Text(
                                      "\$${order.price}",
                                      style: titleNormalBold,
                                    ),
                                    if (order.status == "Order Delivered")
                                      Row(
                                        children: [
                                          Icon(
                                            MdiIcons
                                                .checkboxMarkedCircleOutline,
                                            color: Colors.green,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Delivered",
                                            style: titleMediumBold.copyWith(
                                                color: Colors.green),
                                          )
                                        ],
                                      )
                                    else if (order.status == "Order Canceled")
                                      Row(
                                        children: [
                                          Icon(
                                            MdiIcons.closeCircle,
                                            color: Colors.red,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Canceled",
                                            style: titleMediumBold.copyWith(
                                                color: Colors.red),
                                          )
                                        ],
                                      )
                                    else if (order.status == "Order Accepted")
                                      Row(
                                        children: [
                                          Icon(
                                            MdiIcons.handshakeOutline,
                                            color: Colors.orange,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Accepted",
                                            style: titleMediumBold.copyWith(
                                                color: Colors.orange),
                                          )
                                        ],
                                      )
                                    else if (order.status == "Order Picked up")
                                      Row(
                                        children: [
                                          Icon(
                                            MdiIcons.handOkay,
                                            color: Colors.blueGrey,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Order Picked Up",
                                            style: titleMediumBold.copyWith(
                                                color: Colors.blueGrey),
                                          )
                                        ],
                                      )
                                    else if (order.status == "Order Processed")
                                      Row(
                                        children: [
                                          Icon(
                                            MdiIcons.food,
                                            color: Colors.greenAccent,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Processed",
                                            style: titleMediumBold.copyWith(
                                                color: Colors.greenAccent),
                                          )
                                        ],
                                      )
                                  ],
                                )),
                                IconButton(
                                    onPressed: () {
                                      controller.ordersList[index].displayMore =
                                          !(controller
                                              .ordersList[index].displayMore!);
                                      controller.ordersList.update(
                                          index, controller.ordersList[index]);
                                    },
                                    icon: Icon(controller
                                            .ordersList[index].displayMore!
                                        ? Icons.arrow_drop_up_outlined
                                        : Icons.arrow_drop_down_outlined)),
                              ],
                            ),
                            if (order.displayMore!)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DottedSeparator(
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller
                                              .ordersList[index].displayPrices =
                                          !controller
                                              .ordersList[index].displayPrices!;
                                      controller.ordersList.refresh();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View Ordered Item",
                                          style: titleNormalBold.copyWith(
                                              color: order.oid != null
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Color(0xFFe67800)),
                                        ),
                                        Icon(
                                          order.displayPrices!
                                              ? Icons.arrow_drop_up_outlined
                                              : Icons.arrow_drop_down_outlined,
                                          color: order.oid != null
                                              ? Theme.of(context).primaryColor
                                              : Color(0xFFe67800),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (controller
                                      .ordersList[index].displayPrices!)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFeaeaea),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: addonsList.map((addOn) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: CardContainer2(
                                              sideColor: Colors.white,
                                              backgroundColor: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        addOn.pname ?? "",
                                                        style: titleMediumBold,
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2,
                                                                horizontal: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: order.oid !=
                                                                  null
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withAlpha(30)
                                                              : Color(0xFFe67800)
                                                                  .withAlpha(
                                                                      30),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Text(
                                                          "x${addOn.qty}",
                                                          style: titleMedium.copyWith(
                                                              color: order.oid !=
                                                                      null
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Color(
                                                                      0xFFe67800)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Spacer(),
                                                      Text(
                                                        "\$${addOn.product_price ?? '0.00'}",
                                                        style: titleMediumBold.copyWith(
                                                            color: order.oid !=
                                                                    null
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Color(
                                                                    0xFFe67800)),
                                                      ),
                                                    ],
                                                  ),
                                                  (addOn.addons != null &&
                                                          addOn.addons!
                                                              .isNotEmpty)
                                                      ? SizedBox(
                                                          height: 5,
                                                        )
                                                      : const SizedBox.shrink(),
                                                  (addOn.addons != null &&
                                                          addOn.addons!
                                                              .isNotEmpty)
                                                      ? DottedSeparator(
                                                          color: Colors
                                                              .grey.shade300,
                                                        )
                                                      : const SizedBox.shrink(),
                                                  (addOn.addons != null &&
                                                          addOn.addons!
                                                              .isNotEmpty)
                                                      ? SizedBox(
                                                          height: 5,
                                                        )
                                                      : const SizedBox.shrink(),
                                                  (addOn.addons != null &&
                                                          addOn.addons!
                                                              .isNotEmpty)
                                                      ? Text(
                                                          "ADD-ONS",
                                                          style: titleSmallBold
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  (addOn.addons != null &&
                                                          addOn.addons!
                                                              .isNotEmpty)
                                                      ? ListView.builder(
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          itemCount: addOn
                                                                  .addons
                                                                  ?.length ??
                                                              0,
                                                          itemBuilder:
                                                              (context, idx) {
                                                            return Row(
                                                              children: [
                                                                Icon(
                                                                  MdiIcons.plus,
                                                                  size: 12,
                                                                  color: order.oid !=
                                                                          null
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Color(
                                                                          0xFFe67800),
                                                                ),
                                                                Text(
                                                                    addOn
                                                                            .addons![
                                                                                idx]
                                                                            .name ??
                                                                        "",
                                                                    style: titleMedium.copyWith(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade800)),
                                                                const Spacer(),
                                                                addOn.addons![idx].price ==
                                                                        0
                                                                    ? const SizedBox
                                                                        .shrink()
                                                                    : Text(
                                                                        "\$${addOn.addons![idx].price}",
                                                                        style: titleMediumBold.copyWith(
                                                                            color: order.oid != null
                                                                                ? Theme.of(context).primaryColor
                                                                                : Color(0xFFe67800))),
                                                              ],
                                                            );
                                                          },
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  EasyStepper(
                                    activeStep: order.status == "Order Canceled"
                                        ? 2
                                        : 5,
                                    borderThickness: 1,
                                    stepRadius: 15,
                                    enableStepTapping: false,
                                    lineStyle: LineStyle(
                                        lineLength: 30,
                                        lineType: LineType.normal,
                                        lineThickness: 4,
                                        defaultLineColor: Theme.of(context)
                                            .primaryColor
                                            .withAlpha(70)),
                                    finishedStepBorderColor:
                                        Theme.of(context).primaryColor,
                                    finishedStepTextColor:
                                        Theme.of(context).primaryColor,
                                    finishedStepBackgroundColor: Colors
                                        .transparent, //Theme.of(context).primaryColor.withAlpha(20),
                                    showLoadingAnimation: false,
                                    steps: order.status == "Order Canceled"
                                        ? [
                                            EasyStep(
                                              customStep: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Opacity(
                                                  opacity: 1,
                                                  child: Icon(
                                                    MdiIcons.check,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              customTitle: Text(
                                                'Order\nPlaced',
                                                textAlign: TextAlign.center,
                                                style: titleSmallBold.copyWith(
                                                    height: 1.2),
                                              ),
                                            ),
                                            EasyStep(
                                              customStep: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Opacity(
                                                  opacity: 1,
                                                  child: Icon(
                                                    MdiIcons.check,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              customTitle: Text(
                                                'Order\nCanceled',
                                                textAlign: TextAlign.center,
                                                style: titleSmallBold.copyWith(
                                                    height: 1.2),
                                              ),
                                            ),
                                          ]
                                        : order.status == "Order Accepted"
                                            ? [
                                                EasyStep(
                                                  customStep: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Opacity(
                                                      opacity: 1,
                                                      child: Icon(
                                                        MdiIcons.check,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  customTitle: Text(
                                                    'Order\nPlaced',
                                                    textAlign: TextAlign.center,
                                                    style: titleSmallBold
                                                        .copyWith(height: 1.2),
                                                  ),
                                                ),
                                                EasyStep(
                                                  customStep: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Opacity(
                                                      opacity: 1,
                                                      child: Icon(
                                                        MdiIcons.check,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  customTitle: Text(
                                                    'Order\nAccepted',
                                                    textAlign: TextAlign.center,
                                                    style: titleSmallBold
                                                        .copyWith(height: 1.2),
                                                  ),
                                                ),
                                                EasyStep(
                                                  customStep: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Opacity(
                                                      opacity: 1,
                                                      child: Icon(
                                                        MdiIcons
                                                            .clockTimeElevenOutline,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  customTitle: Text(
                                                    'Order\nProcessed',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        titleSmallBold.copyWith(
                                                            height: 1.2,
                                                            color: Colors.grey),
                                                  ),
                                                ),
                                                EasyStep(
                                                  customStep: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Opacity(
                                                      opacity: 1,
                                                      child: Icon(
                                                        MdiIcons
                                                            .clockTimeFiveOutline,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  customTitle: Text(
                                                    'Order\nPicked',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        titleSmallBold.copyWith(
                                                            height: 1.2,
                                                            color: Colors.grey),
                                                  ),
                                                ),
                                                EasyStep(
                                                  customStep: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Opacity(
                                                      opacity: 1,
                                                      child: Icon(
                                                        MdiIcons
                                                            .clockTimeEightOutline,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  customTitle: Text(
                                                    'Order\nDelivered',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        titleSmallBold.copyWith(
                                                            height: 1.2,
                                                            color: Colors.grey),
                                                  ),
                                                ),
                                              ]
                                            : order.status!.toLowerCase() ==
                                                    "Order Picked Up"
                                                        .toLowerCase()
                                                ? [
                                                    EasyStep(
                                                      customStep: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Opacity(
                                                          opacity: 1,
                                                          child: Icon(
                                                            MdiIcons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      customTitle: Text(
                                                        'Order\nPlaced',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: titleSmallBold
                                                            .copyWith(
                                                                height: 1.2),
                                                      ),
                                                    ),
                                                    EasyStep(
                                                      customStep: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Opacity(
                                                          opacity: 1,
                                                          child: Icon(
                                                            MdiIcons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      customTitle: Text(
                                                        'Order\nAccepted',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: titleSmallBold
                                                            .copyWith(
                                                                height: 1.2),
                                                      ),
                                                    ),
                                                    EasyStep(
                                                      customStep: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Opacity(
                                                          opacity: 1,
                                                          child: Icon(
                                                            MdiIcons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      customTitle: Text(
                                                        'Order\nProcessed',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: titleSmallBold
                                                            .copyWith(
                                                                height: 1.2),
                                                      ),
                                                    ),
                                                    EasyStep(
                                                      customStep: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Opacity(
                                                          opacity: 1,
                                                          child: Icon(
                                                            MdiIcons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      customTitle: Text(
                                                        'Order\nPicked',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: titleSmallBold
                                                            .copyWith(
                                                          height: 1.2,
                                                        ),
                                                      ),
                                                    ),
                                                    EasyStep(
                                                      customStep: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Opacity(
                                                          opacity: 1,
                                                          child: Icon(
                                                            MdiIcons
                                                                .clockTimeEightOutline,
                                                            color: Colors.grey,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      customTitle: Text(
                                                        'Order\nDelivered',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: titleSmallBold
                                                            .copyWith(
                                                                height: 1.2,
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                    ),
                                                  ]
                                                : order.status!.toLowerCase() ==
                                                        "Order Processed"
                                                            .toLowerCase()
                                                    ? [
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nPlaced',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height:
                                                                        1.2),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nAccepted',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height:
                                                                        1.2),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nProcessed',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                titleSmallBold
                                                                    .copyWith(
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons
                                                                    .clockTimeFiveOutline,
                                                                color:
                                                                    Colors.grey,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nPicked',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height: 1.2,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons
                                                                    .clockTimeEightOutline,
                                                                color:
                                                                    Colors.grey,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nDelivered',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height: 1.2,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                      ]
                                                    : [
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nPlaced',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height:
                                                                        1.2),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nAccepted',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height:
                                                                        1.2),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nProcessed',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                titleSmallBold
                                                                    .copyWith(
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nPicked',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height:
                                                                        1.2),
                                                          ),
                                                        ),
                                                        EasyStep(
                                                          customStep: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Opacity(
                                                              opacity: 1,
                                                              child: Icon(
                                                                MdiIcons.check,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          customTitle: Text(
                                                            'Order\nDelivered',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: titleSmallBold
                                                                .copyWith(
                                                                    height:
                                                                        1.2),
                                                          ),
                                                        ),
                                                      ],
                                    onStepReached: (index) {
                                      controller.activeStep.value = index;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                          ],
                        ),
                        //if(order.status! == "Order Delivered")
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text("No order found"),
          );
        }
      }), onRefresh: () async {
        await controller.getMyOrders();
      }),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/models/orders/my_orders.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/event_actions.dart';
import 'package:localcooks_app/main.dart';

import '../../../../common/dialog_manager.dart';
import '../../../providers/dio_client.dart';

class MyOrderController extends GetxController{

  var event = EventAction.NO_RECORD.obs;
  final DioClient _httpClient = DioClient();
  var ordersList = <MyOrdersData>[].obs;
  var activeStep = 0.obs;
  Timer? timer;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    getMyOrders();
    super.onInit();
  }

  Future<void> getMyOrders() async{

    HomeController homeController = Get.find();
    ordersList.clear();

    try {
      event.value = EventAction.LOADING;
      var response = await _httpClient.get(
        'controllers/orders_api.php',
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${homeController.loginController.user.value.token}",
              }
          )
      );
      event.value = EventAction.FETCH;
      var orders = MyOrders.fromJson(response);
      if(orders != null){
        if(orders.status == 200){
          ordersList.assignAll(orders.data?.reversed ?? []);
          if(ordersList.isEmpty){
            event.value = EventAction.NO_RECORD;
          }else{
            timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
              getMyOrders2();
            });
          }
        }else{
          event.value = EventAction.NO_RECORD;
        }
      }else{
        event.value = EventAction.NO_RECORD;
      }
    } on DioException catch (_) {
      event.value = EventAction.NO_RECORD;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> getMyOrders2() async{
    if(Get.currentRoute != Routes.ROOT){
      return;
    }

    HomeController homeController = Get.find();

    try {
      var response = await _httpClient.get(
        'controllers/orders_api.php',
          options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${homeController.loginController.user.value.token}",
              }
          )
      );
      var orders = MyOrders.fromJson(response);
      if(orders != null){
        if(orders.status == 200){
          var myOrders = List<MyOrdersData>.of(orders.data?.reversed ?? <MyOrdersData>[]);
          if(myOrders.isEmpty){
            event.value = EventAction.NO_RECORD;
            timer!.cancel();
          }else{
            if(myOrders.length == ordersList.length){
              for(var i=0; i<myOrders.length;i++){
                int idx = ordersList.indexWhere((ord) => ord.oid == myOrders[i].oid);
                if(idx >= 0){
                  if(ordersList[idx].displayMore! && !myOrders[i].displayMore!){
                    myOrders[i].displayMore = true;
                    ordersList.update(idx, myOrders[i]);
                  }
                  if(ordersList[idx].displayPrices! && !myOrders[i].displayPrices!){
                    myOrders[i].displayPrices = true;
                    ordersList.update(idx, myOrders[i]);
                  }
                }
              }
            }else{
              ordersList.value = myOrders;
              ordersList.refresh();
            }
            //event.value = EventAction.FETCH;
          }
        }
      }
    } on DioException catch (_) {

    }
  }

  List<MyOrdersData> updateListWithChanges({
    required List<MyOrdersData> originalList,
    required List<MyOrdersData> updatedList,
  }) {
    final updatedMap = {for (var obj in updatedList) obj.oid: obj};

    return originalList.map((originalObj) {
      // If the object exists in the updated list, return the updated version
      if (updatedMap.containsKey(originalObj.oid)) {
        return updatedMap[originalObj.oid]!;
      }
      // Otherwise keep the original
      return originalObj;
    }).toList();
  }

  @override
  void onClose() {
    timer!.cancel();
    super.onClose();
  }

}
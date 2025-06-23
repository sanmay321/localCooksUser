import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/models/shops/product_categories.dart';
import 'package:localcooks_app/app/models/shops/schedule_model.dart';
import 'package:localcooks_app/app/models/shops/shops.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/common/event_actions.dart';

import '../../../../common/dialog_manager.dart';
import '../../../models/shops/shop_cart.dart';
import '../../../providers/dio_client.dart';

class ShopDetailController extends GetxController{

  var shop = Shops().obs;
  final DioClient _httpClient = DioClient();
  HomeController homeController = Get.find();
  var totalCardCount = 0.obs;
  var productCategoriesList = <ProductCategoriesData>[];
  var event = EventAction.NO_RECORD.obs;
  var eventSchedule = EventAction.NO_RECORD.obs;
  var scheduleData = ScheduleData().obs;
  RxInt deliveryOptionSwitch = 1.obs;

  @override
  void onInit() {
    shop.value = Get.arguments;
    getCartCount(shop.value.sid!);
    getProducts(shop.value.sid!);
    getSchedule(shop.value.sid!);
    super.onInit();
  }

  Future<void> getCartCount(int shopId) async{
    try {
      var response = await _httpClient.get(
        'controllers/cart_count_api.php',
        queryParameters: {
          "sid" : shopId
        },
        options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${homeController.loginController.user.value.token}",
            }
        )
      );
      var shopData = ShopCart.fromJson(response);
      debugPrint(shopData.toString());
      if(shopData != null && shopData.data != null){
        totalCardCount.value = shopData.data!.total_items!;
        totalCardCount.refresh();
      }
    } on DioException catch (_) {
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> getProducts(int shopId) async{
    try {
      event.value = EventAction.LOADING;
      var response = await _httpClient.get(
        'controllers/category_api.php',
        queryParameters: {
          "sid" : shopId
        },
      );
      var productCategories = ProductCategories.fromJson(response);
      event.value = EventAction.FETCH;
      if(productCategories != null && productCategories.data != null && productCategories.data!.isNotEmpty){
        productCategoriesList.addAll(productCategories.data ?? []);
        if(productCategoriesList.isEmpty){
          event.value = EventAction.NO_RECORD;
        }
      }
      debugPrint(productCategories.message);
    } on DioException catch (_) {
      event.value = EventAction.ERROR;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  Future<void> getSchedule(int shopId) async{
    try {
      eventSchedule.value = EventAction.LOADING;
      var response = await _httpClient.get(
        'controllers/shop_schedule_api.php',
        queryParameters: {
          "sid" : shopId
        },
      );
      var schedule = Schedule.fromJson(response);
      eventSchedule.value = EventAction.FETCH;
      if(schedule != null && schedule.data != null){
        scheduleData.value = schedule.data!;
        getDaysStartingFromToday(scheduleData.value.toJson());
      }
    } on DioException catch (_) {
      eventSchedule.value = EventAction.ERROR;
      DialogManager.showErrorDialogNoTitle(_.toString());
    }
  }

  final daysList = <MapEntry<String, dynamic>>[].obs;

  void getDaysStartingFromToday(Map<String, dynamic> openingHours) {
    const dayOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final currentDayIndex = (now.weekday - 1) % 7; // Monday is 0

    // Create ordered list of entries
    final entries = openingHours.entries.toList();
    entries.sort((a, b) {
      return dayOrder.indexOf(a.key).compareTo(dayOrder.indexOf(b.key));
    });

    // Reorder to start from today
    daysList.addAll([
      ...entries.sublist(currentDayIndex),
      ...entries.sublist(0, currentDayIndex),
    ]);
  }

  String formatTime(String? time) {
    if (time == null) return '--:--';

    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  bool isToday(String dayAbbreviation) {
    const dayOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final currentDayIndex = (now.weekday - 1) % 7; // Monday is 0
    return dayOrder.indexOf(dayAbbreviation) == currentDayIndex;
  }

}
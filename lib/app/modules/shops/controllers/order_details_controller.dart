import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/models/orders/my_orders.dart';
import 'package:localcooks_app/app/models/shops/cart.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/app/modules/home/controllers/my_order_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/dialog_manager.dart';
import '../../../providers/dio_client.dart';

class OrderDetailsController extends GetxController {
  final DioClient _httpClient = DioClient();
  var isLoading = true.obs;
  var orderDetails = Rxn<MyOrdersData>();
  var orderedItems = <CartItems2>[].obs;
  var isOrderRated = false.obs;

  final MyOrderController _myOrderController = Get.find<MyOrderController>();

  @override
  void onInit() {
    super.onInit();
    loadOrderDetails();
  }

  void loadOrderDetails() {
    try {
      isLoading.value = true;

      // Get order ID from parameters
      final Map<String, dynamic> params = Get.parameters;
      if (params.containsKey('id')) {
        final id = int.tryParse(params['id']);
        if (id != null) {
          // Find the order in the existing orders list
          final order = _myOrderController.ordersList
              .firstWhereOrNull((o) => o.oid == id);

          if (order != null) {
            orderDetails.value = order;

            // Parse ordered items from addons field
            if (order.addons != null && order.addons!.isNotEmpty) {
              try {
                final List<dynamic> addonsJson = json.decode(order.addons!);
                orderedItems.value = addonsJson
                    .map((item) => CartItems2.fromJson(item))
                    .toList();
              } catch (e) {
                debugPrint('Error parsing addons: $e');
              }
            }

            // Check if order has been rated
            checkIfOrderRated(id);
          } else {
            DialogManager.showErrorDialog('Error', 'Order not found');
          }
        } else {
          DialogManager.showErrorDialog('Error', 'Invalid order ID');
        }
      } else {
        DialogManager.showErrorDialog('Error', 'No order ID provided');
      }
    } catch (e) {
      DialogManager.showErrorDialog(
          'Error', 'An error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get subtotal (without delivery fee)
  double getSubtotal() {
    double subtotal = 0.0;
    for (var item in orderedItems) {
      subtotal += (item.productPrice ?? 0) * (item.qty ?? 1);
      if (item.addonTotal != null) {
        subtotal += item.addonTotal!.toDouble();
      }
    }
    return subtotal;
  }

  // Helper method to get delivery fee
  double getDeliveryFee() {
    return double.tryParse(orderDetails.value?.dcharge ?? '0.0') ?? 0.0;
  }

  // Helper method to get total amount
  double getTotalAmount() {
    return double.tryParse(orderDetails.value?.price ?? '0.0') ?? 0.0;
  }

  // Method to handle "Get Help" button
  void getHelp() {
    DialogManager.showErrorDialog(
        'Help', 'Contact customer support for assistance with this order.');
  }

  Future<void> checkIfOrderRated(int orderId) async {
    try {
      // Get the token from the home controller
      final homeController = Get.find<HomeController>();
      final token = homeController.loginController.user.value.token;

      debugPrint('Checking if order $orderId has been rated');

      var response = await _httpClient.get(
          'controllers/rating_api.php', // Use the rating API endpoint directly
          queryParameters: {"oid": orderId},
          options: Options(
            headers: {
              "Authorization": "Bearer $token", // Add authorization header
            },
          ));

      debugPrint('Check rating response: $response');

      // Check if the response indicates the order has been rated
      if (response != null) {
        debugPrint('Full response: $response');

        // Check for data in the response
        if (response['data'] != null) {
          // If there's data, the order has been rated
          isOrderRated.value = true;
          debugPrint('Order has been rated (data found)');
        } else if (response['status'] == 200) {
          // If status is 200, the order has been rated
          isOrderRated.value = true;
          debugPrint('Order has been rated (status 200)');
        } else if (response['message']
                ?.toString()
                .toLowerCase()
                .contains('rating found') ==
            true) {
          // If the message contains 'rating found', the order has been rated
          isOrderRated.value = true;
          debugPrint('Order has been rated (message: rating found)');
        } else if (response['message']
                ?.toString()
                .toLowerCase()
                .contains('already rated') ==
            true) {
          // If the message contains 'already rated', the order has been rated
          isOrderRated.value = true;
          debugPrint('Order has been rated (message: already rated)');
        } else {
          // Otherwise, the order has not been rated
          isOrderRated.value = false;
          debugPrint('Order has not been rated');
        }
      } else {
        // If there's no response, assume the order has not been rated
        isOrderRated.value = false;
        debugPrint('No response from check rating API');
      }
    } catch (e) {
      // If there's an error, log it and assume the order hasn't been rated
      isOrderRated.value = false;
      if (e is DioException) {
        debugPrint(
            'Dio Error checking rating: ${e.type}, Message: ${e.message}');
        debugPrint('Response: ${e.response?.data}');
      } else {
        debugPrint('Error checking if order is rated: ${e.toString()}');
      }
    }
  }

  Future<void> navigateToRateOrder() async {
    if (orderDetails.value?.oid != null) {
      // First check if the order has already been rated
      await checkIfOrderRated(orderDetails.value!.oid!);

      // If the order is already rated, show a message
      if (isOrderRated.value) {
        DialogManager.showErrorDialog(
            'Already Rated', 'You have already rated this order.');
        return;
      }

      // Navigate to the rating screen
      final result = await Get.toNamed(Routes.RATE_ORDER,
          parameters: {'id': orderDetails.value!.oid.toString()});

      // If rating was successful, refresh the order details
      if (result == true) {
        isOrderRated.value = true;
      } else {
        // If the result wasn't explicitly true, check again
        await checkIfOrderRated(orderDetails.value!.oid!);
      }
    }
  }
}

// Class to parse ordered items from addons field
class CartItems2 {
  String? cartid;
  String? pid;
  int? qty;
  double? productPrice; // Changed from product_price to productPrice
  String? pname;
  int? addonTotal;
  List<Addons>? addons;
  String? pimage;

  CartItems2(
      {this.cartid,
      this.pid,
      this.qty,
      this.productPrice,
      this.pname,
      this.addonTotal,
      this.addons,
      this.pimage});

  factory CartItems2.fromJson(Map<String, dynamic> json) {
    return CartItems2(
        cartid: json['cartid'],
        pid: json['pid'],
        qty: json['qty'] is String ? int.tryParse(json['qty']) : json['qty'],
        productPrice: json['product_price'] is String
            ? double.tryParse(json['product_price'])
            : (json['product_price'] ?? 0.0).toDouble(),
        pname: json['pname'],
        addonTotal: json['addonTotal'],
        addons: json['addons'] != null
            ? (json['addons'] as List).map((e) => Addons.fromJson(e)).toList()
            : null,
        pimage: json['pimage']);
  }
}

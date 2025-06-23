import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/models/orders/my_orders.dart';
import 'package:localcooks_app/app/modules/home/controllers/my_order_controller.dart';
import 'package:localcooks_app/common/dialog_manager.dart';
import '../../../providers/dio_client.dart';
import '../../home/controllers/home_controller.dart';

class RateOrderController extends GetxController {
  final DioClient _httpClient = DioClient();
  var isLoading = false.obs;
  var orderDetails = Rxn<MyOrdersData>();
  var rating = 0.obs;
  var comment = ''.obs;
  final commentController = TextEditingController();

  // Check if order has been rated
  var isOrderRated = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrderDetails();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
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
          final MyOrderController myOrderController =
              Get.find<MyOrderController>();
          final order =
              myOrderController.ordersList.firstWhereOrNull((o) => o.oid == id);

          if (order != null) {
            orderDetails.value = order;
            // Check if order has been rated
            checkIfOrderRated(id);
          } else {
            DialogManager.showErrorDialog('Error', 'Order not found');
            Get.back();
          }
        } else {
          DialogManager.showErrorDialog('Error', 'Invalid order ID');
          Get.back();
        }
      } else {
        DialogManager.showErrorDialog('Error', 'No order ID provided');
        Get.back();
      }
    } catch (e) {
      DialogManager.showErrorDialog(
          'Error', 'An error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void setRating(int value) {
    rating.value = value;
  }

  void setComment(String value) {
    comment.value = value;
  }

  Future<void> checkIfOrderRated(int orderId) async {
    try {
      isLoading.value = true;

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
    } finally {
      isLoading.value = false;
    }
  }

  // Modify the submitRating method to address these issues
  Future<bool> submitRating() async {
    if (rating.value == 0) {
      DialogManager.showErrorDialog('Error', 'Please select a rating');
      return false;
    }

    if (comment.value.isEmpty) {
      DialogManager.showErrorDialog('Error', 'Please enter a comment');
      return false;
    }

    try {
      isLoading.value = true;

      // Get the token from the home controller
      final homeController = Get.find<HomeController>();
      final token = homeController.loginController.user.value.token;

      // Convert data to JSON string manually
      final Map<String, dynamic> ratingData = {
        "rating": rating.value,
        "description": comment.value,
      };

      var response = await _httpClient.post('controllers/rating_api.php',
          queryParameters: {
            "oid": orderDetails.value?.oid,
            "sid": orderDetails.value?.sid,
            "lid": orderDetails.value?.lid ?? 10,
          },
          data: json.encode(ratingData), // Encode as JSON string
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token", // Add authorization header
            },
            contentType:
                Headers.jsonContentType, // Ensure content type is set correctly
          ));

      debugPrint('Rating API Response: $response');

      // Check for success in the response
      // The API might return status 200 even for errors, so check the message too
      if (response != null &&
          (response['status'] == 200 ||
              response['message']
                      ?.toString()
                      .toLowerCase()
                      .contains('success') ==
                  true)) {
        isOrderRated.value = true;
        Get.back(); // First close the current screen
        DialogManager.showSuccessDialogOk('Thank you for your feedback!', () {
          // Do nothing, just close the dialog
        });
        return true;
      } else {
        DialogManager.showErrorDialog(
            'Error', response['message'] ?? 'Failed to submit rating');
        return false;
      }
    } catch (e) {
      // Add more detailed error logging
      if (e is DioException) {
        debugPrint('Dio Error: ${e.type}, Message: ${e.message}');
        debugPrint('Response: ${e.response?.data}');
      }
      DialogManager.showErrorDialog(
          'Error', 'An error occurred: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

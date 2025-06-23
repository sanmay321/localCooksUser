import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/global_widgets/loading_indicator.dart';
import 'package:localcooks_app/app/modules/shops/controllers/rate_order_controller.dart';
import 'package:localcooks_app/common/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RateOrderScreen extends StatelessWidget {
  final controller = Get.put(RateOrderController());

  RateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate Your Order"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: LoadingIndicator(isVisible: true));
        } else if (controller.orderDetails.value == null) {
          return Center(child: Text("Order not found"));
        } else if (controller.isOrderRated.value) {
          return _buildAlreadyRatedContent(context);
        } else {
          return _buildRatingContent(context);
        }
      }),
    );
  }

  Widget _buildAlreadyRatedContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.checkCircleOutline,
            size: 80,
            color: Colors.green,
          ),
          SizedBox(height: 16),
          Text(
            "You've already rated this order",
            style: titleLargeBold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            "Thank you for your feedback!",
            style: titleNormal.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          CustomButton(
            onPressed: () => Get.back(),
            // text: "Back to Order Details",
            buttonTitle: "Back to Order Details",
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order info card
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(MdiIcons.clipboardListOutline,
                        color: Theme.of(context).primaryColor),
                    SizedBox(width: 8),
                    Text("Order #${controller.orderDetails.value?.oid}",
                        style: titleBold),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "How was your experience with this order?",
                  style: titleNormal.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Rating section
          Center(
            child: Column(
              children: [
                Text(
                  "Rate your order",
                  style: titleLargeBold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Obx(() => RatingBar(
                      onRatingChanged: (rating) =>
                          controller.setRating(rating.toInt()),
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      halfFilledIcon: Icons.star_half,
                      isHalfAllowed: false,
                      initialRating: controller.rating.value.toDouble(),
                      maxRating: 5,
                      filledColor: Colors.amber,
                      emptyColor: Colors.amber,
                      size: 48,
                    )),
                SizedBox(height: 8),
                Obx(() => Text(
                      _getRatingText(controller.rating.value),
                      style: titleMediumBold.copyWith(
                        color: _getRatingColor(controller.rating.value),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Comment section
          Text(
            "Share your feedback",
            style: titleBold,
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller.commentController,
            onChanged: controller.setComment,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Tell us about your experience...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          SizedBox(height: 32),

          // Submit button
          Center(
            child: CustomButton(
              onPressed: () async {
                if (await controller.submitRating()) {
                  // If rating was successful, go back to order details
                  Get.back(result: true);
                }
              },
              buttonTitle: "Submit Rating",
              width: 200,
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Poor";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      case 5:
        return "Excellent";
      default:
        return "Tap to rate";
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

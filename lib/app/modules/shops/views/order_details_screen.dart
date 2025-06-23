import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/global_widgets/dotted_separator.dart';
import 'package:localcooks_app/app/global_widgets/loading_indicator.dart';
import 'package:localcooks_app/app/modules/shops/controllers/order_details_controller.dart';
import 'package:localcooks_app/common/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderDetailsScreen extends StatelessWidget {
  final controller = Get.put(OrderDetailsController());

  OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: LoadingIndicator(isVisible: true));
        } else if (controller.orderDetails.value == null) {
          return Center(child: Text("No order details found"));
        } else {
          return _buildOrderDetailsContent(context);
        }
      }),
    );
  }

  Widget _buildOrderDetailsContent(BuildContext context) {
    final order = controller.orderDetails.value!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(MdiIcons.clipboardListOutline,
                      color: Theme.of(context).primaryColor),
                  SizedBox(width: 8),
                  Text("Order Details", style: titleBold),
                ],
              ),
              _buildStatusBadge(order.status ?? "")
            ],
          ),
          SizedBox(height: 16),

          // Order Information Card
          CardContainer(
            child: Column(
              children: [
                _buildInfoRow("Order #:", "${order.oid}"),
                SizedBox(height: 12),
                _buildInfoRow("Date:", _formatDate(order.ordertime)),
                SizedBox(height: 12),
                _buildInfoRow("Time:", _formatTime(order.ordertime)),
                SizedBox(height: 12),
                _buildPaymentMethodRow(context),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Local Cook Information
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(MdiIcons.storeOutline, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Local Cook", style: titleBold),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://via.placeholder.com/50", // Replace with actual cook image
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey.shade200),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text("Cook's Kitchen",
                        style:
                            titleNormalBold), // Replace with actual cook name
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Ordered Items
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(MdiIcons.foodOutline, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Ordered Items", style: titleBold),
                      ],
                    ),
                    Text("Invoice #${order.oid}416",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 16),

                // Item headers
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("Qty",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Text("Item",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Price",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right)),
                  ],
                ),
                SizedBox(height: 8),
                DottedSeparator(),
                SizedBox(height: 8),

                // List of ordered items
                Obx(() => Column(
                      children: controller.orderedItems
                          .map((item) => _buildOrderedItemRow(
                              item.qty ?? 1,
                              item.pname ?? "",
                              (item.productPrice ?? 0) * (item.qty ?? 1)))
                          .toList(),
                    )),

                SizedBox(height: 16),
                DottedSeparator(),
                SizedBox(height: 16),

                // Order summary
                _buildSummaryRow("Subtotal", controller.getSubtotal()),
                SizedBox(height: 8),
                _buildSummaryRow("Delivery Fee", controller.getDeliveryFee()),
                SizedBox(height: 8),
                _buildSummaryRow("Total", controller.getTotalAmount(),
                    isTotal: true),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Customer notes if any
          if (order.description != null && order.description!.isNotEmpty)
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(MdiIcons.messageTextOutline, color: Colors.amber),
                      SizedBox(width: 8),
                      Text("Customer Notes", style: titleBold),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(order.description ?? ""),
                ],
              ),
            ),

          // Action buttons
          SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rate Order button - only show if order is delivered and not yet rated
                if (order.status == "Order Delivered")
                  Obx(
                    () => controller.isOrderRated.value
                        ? ElevatedButton.icon(
                            onPressed: null, // Disabled
                            icon: Icon(Icons.star, color: Colors.grey),
                            label: Text("Already Rated"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.grey.shade200,
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: controller.navigateToRateOrder,
                            icon: Icon(Icons.star, color: Colors.amber),
                            label: Text("Rate Order"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.amber.shade100,
                            ),
                          ),
                  ),

                // Add spacing between buttons
                if (order.status == "Order Delivered") SizedBox(width: 16),

                // Help button
                ElevatedButton.icon(
                  onPressed: controller.getHelp,
                  icon: Icon(Icons.help_outline),
                  label: Text("Get Help"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor = Colors.grey;
    String displayStatus = status;

    if (status == "Order Delivered") {
      badgeColor = Colors.green;
      displayStatus = "Delivered";
    } else if (status == "Order Placed") {
      badgeColor = Colors.blue;
      displayStatus = "Placed";
    } else if (status == "Order Canceled") {
      badgeColor = Colors.red;
      displayStatus = "Canceled";
    } else if (status.contains("Preparing")) {
      badgeColor = Colors.orange;
      displayStatus = "Preparing";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPaymentMethodRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Payment Method:", style: TextStyle(color: Colors.grey.shade700)),
        Row(
          children: [
            Text("Online Payment",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "Paid",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderedItemRow(int quantity, String itemName, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(quantity.toString())),
          Expanded(flex: 3, child: Text(itemName)),
          Expanded(
            flex: 1,
            child: Text(
              "\$${price.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                isTotal ? titleBold : TextStyle(color: Colors.grey.shade700)),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return "";
    try {
      final dateTime = DateFormat("dd-MM-yyyy hh:mm:ss a").parse(dateTimeStr);
      return DateFormat("MMMM dd, yyyy").format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _formatTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return "";
    try {
      final dateTime = DateFormat("dd-MM-yyyy hh:mm:ss a").parse(dateTimeStr);
      return DateFormat("h:mm a").format(dateTime);
    } catch (e) {
      return "";
    }
  }
}

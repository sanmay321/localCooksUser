import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../common/constants.dart';

class StripePaymentService {
  static Future<String?> createPaymentIntent(
      String amount, String currency) async {
    try {
      final url = Uri.parse('${StripeConfig.stripeUrl}/payment_intents');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${StripeConfig.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['client_secret'];
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      return null;
    }
  }

  static Future<bool> confirmPayment(
      String clientSecret, BuildContext context) async {
    try {
      // 1. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      // 2. Confirm payment
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: 'johnpaul6988@gmail.com',
              phone: '+17096892942',
              address: Address(
                city: 'St. John\'s',
                country: 'CA',
                line1: 'Fusion Dance Studio, 82 O\'leary Ave',
                line2: '',
                state: 'NL',
                postalCode: '00000',
              ),
            ),
          ),
        ),
      );

      return true;
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.error.localizedMessage}')),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }
}
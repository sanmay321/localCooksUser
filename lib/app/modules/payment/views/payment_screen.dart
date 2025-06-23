import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';

import '../../../services/stripe_payment_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;

  const PaymentScreen({
    Key? key,
    required this.amount,
    this.currency = 'CAD',
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = CardFormEditController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Convert amount to cents (Stripe requires amount in smallest currency unit)
      final amountInCents = (widget.amount * 100).toInt().toString();

      // 1. Create payment intent on backend
      final clientSecret = await StripePaymentService.createPaymentIntent(
          amountInCents, widget.currency);

      if (clientSecret == null) {
        throw Exception('Failed to create payment intent');
      }

      // 2. Confirm payment
      final paymentSuccess = await StripePaymentService.confirmPayment(clientSecret, context);

      if (paymentSuccess) {
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      Navigator.of(context).pop(false); // Return success
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );*/
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CardFormField(
                controller: _cardController,
                countryCode: "CA",
                enablePostalCode: true,
                style: CardFormStyle(
                  backgroundColor: Colors.white,
                  borderColor: Colors.grey,
                  borderRadius: 16,
                  textColor: Colors.black,
                  placeholderColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: _isLoading ? null : _handlePayment,
                buttonTitle: 'Pay \$${widget.amount.toStringAsFixed(2)}'
              ),
            ],
          ),
        ),
      ),
    );
  }
}
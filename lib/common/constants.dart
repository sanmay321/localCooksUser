import 'package:flutter/material.dart';

const imageBaseURL = "https://localcook.shop/app/sadmin/images/";
const locationId = 11;
const shopClosed = "Shop is currently closed";

const titleBold = TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: 17
);

const title = TextStyle(
    fontSize: 17
);

const titleLargeBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 20
);

const titleLarge = TextStyle(
    fontSize: 20
);

const titleNormalBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 14
);

const titleNormal = TextStyle(
    fontSize: 14
);

const titleMediumBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 12
);

const titleMedium = TextStyle(
    fontSize: 12
);

const titleSmallBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 10
);

const titleSmall = TextStyle(
    fontSize: 10
);

class StripeConfig {
  static const String publishableKey = 'pk_test_51Om3i3CcxmpT621JxYdM8wc6L5eaB7cdhkVp4fbZOYRuuYWqHKnEDKIOn44PglGZhAoa7tMYVAKqFFSSFeZecmCV00qP9fBFMO';
  static const String secretKey = 'sk_test_51Om3i3CcxmpT621JF9WnBQGWe4D3AvFv1y0Ks6CcFpNtxF6v81DivmT0jiKDn79OQ3VFGmt5Ulq9S8W92yZDdCE600n8B9xroR';
  static const String stripeUrl = 'https://api.stripe.com/v1';
  static const String stripeMerchantId = 'your_merchant_id'; // For Apple Pay
}
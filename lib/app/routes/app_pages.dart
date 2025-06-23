import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/auth/views/login_screen.dart';
import 'package:localcooks_app/app/modules/auth/views/otp_screen.dart';
import 'package:localcooks_app/app/modules/auth/views/update_profile_screen.dart';
import 'package:localcooks_app/app/modules/deactivate/bindings/deactivate_binding.dart';
import 'package:localcooks_app/app/modules/deactivate/views/deactivate_account_screen.dart';
import 'package:localcooks_app/app/modules/shops/bindings/cart_binding.dart';
import 'package:localcooks_app/app/modules/shops/bindings/reviews_binding.dart';
import 'package:localcooks_app/app/modules/shops/bindings/shop_details_binding.dart';
import 'package:localcooks_app/app/modules/home/views/home_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/cart_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/checkout_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/confirm_delivery_address_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/order_summary_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/order_details_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/rate_order_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/product_detail_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/reviews_screen.dart';
import 'package:localcooks_app/app/modules/shops/views/shop_details_screen.dart';
import 'package:localcooks_app/app/modules/splash/bindings/splash_binding.dart';
import 'package:localcooks_app/app/modules/splash/views/splash_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/shops/bindings/product_details_binding.dart';
import 'app_routes.dart';

class AppPages {
  static var INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: Routes.SPLASH,
        page: () => SplashScreen(),
        binding: SplashBinding()),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => OtpScreen(),
    ),
    GetPage(
      name: Routes.DEACTIVATE_ACCOUNT,
      page: () => DeActivateAccountScreen(),
    ),
    GetPage(
      name: Routes.UPDATE_PROFILE,
      page: () => UpdateProfileScreen(),
    ),
    GetPage(
      name: Routes.ROOT,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SHOP_DETAILS,
      page: () => ShopDetailsScreen(),
      binding: ShopDetailBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAILS,
      page: () => ProductDetailScreen(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => CartScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: Routes.REVIEWS,
      page: () => ReviewsScreen(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => CheckoutScreen(),
      //binding: ReviewBinding(),
    ),
    GetPage(
      name: Routes.CONFIRM_DELIVERY_ADDRESS,
      page: () => ConfirmDeliveryAddressScreen(),
      //binding: ReviewBinding(),
    ),
    GetPage(
      name: Routes.ORDER_SUMMARY,
      page: () => OrderSummaryScreen(),
      //binding: ReviewBinding(),
    ),
    GetPage(
      name: Routes.ORDER_DETAILS,
      page: () => OrderDetailsScreen(),
      //binding: ReviewBinding(),
    ),
    GetPage(
      name: Routes.RATE_ORDER,
      page: () => RateOrderScreen(),
      //binding: ReviewBinding(),
    ),
  ];
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/routes/app_pages.dart';
import 'package:localcooks_app/app/services/fcm_service.dart';
import 'package:localcooks_app/common/theme.dart';

import 'app/services/background/local_storage_service.dart';
import 'common/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Configure Stripe
  Stripe.publishableKey = StripeConfig.publishableKey;
  Stripe.merchantIdentifier = StripeConfig.stripeMerchantId;
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  await Get.putAsync(() => LocalStorageService().init());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  final fcmController = Get.put(FCMService());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeLight,
      darkTheme: themeDark,
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
    );
  }
}

extension ListUpdate<T> on List<T> {
  List<T> update(int pos, T t) {
    List<T> list = [];
    list.add(t);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}

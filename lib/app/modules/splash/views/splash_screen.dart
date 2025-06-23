import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/app_logo.png", height: Get.height/3,).animate()
          .shimmer(duration: const Duration(seconds: 2),),),
    );
  }
}

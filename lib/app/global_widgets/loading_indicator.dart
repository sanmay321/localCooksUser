import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_animate/flutter_animate.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isVisible;
  final String loadingText;

  const LoadingIndicator({
    super.key,
    required this.isVisible,
    this.loadingText = '',
  });

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 20),
                    Text(loadingText, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600,),).animate()
                        .shimmer(duration: const Duration(seconds: 2), color: Theme.of(context).primaryColor),
                    /*AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          loadingText,
                          textStyle: Get.textTheme.titleMedium!.copyWith(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          colors: [
                            Get.theme.primaryColor,
                            Get.theme.primaryColor.withOpacity(0.3),
                          ],
                          speed: const Duration(milliseconds: 250),
                        ),
                      ],
                      pause: Duration.zero,
                      repeatForever: true,
                    )*/
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

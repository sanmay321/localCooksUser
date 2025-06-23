import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {

  Function()? onPressed;
  String buttonTitle;
  double? height;
  double? width;
  Color? backgroundColor;
  Color? textColor;
  Color? borderColor;
  IconData? icon;
  CustomButton({super.key, required this.onPressed, required this.buttonTitle, this.height, this.width, this.backgroundColor, this.textColor, this.borderColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        minWidth: width ?? Get.width,
        height: height ?? 50,
        color: backgroundColor ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? Row(
              children: [
                Icon(icon ?? Icons.arrow_right, size: 18, color: textColor ?? Colors.white,),
                const SizedBox(width: 10,),
              ],
            ) : const SizedBox.shrink(),
            Text(buttonTitle, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor ?? Colors.white, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis,)
          ],
        )
    );
  }
}

import 'package:flutter/material.dart';

class CardContainer2 extends StatelessWidget {

  Color? sideColor;
  Color? backgroundColor;
  Widget? child;
  double? width;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;

  CardContainer2({this.sideColor, this.child, this.width, this.padding, this.margin, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: sideColor ?? Theme.of(context).primaryColor,
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(10),
        margin: margin ?? EdgeInsets.only(left: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor ?? Colors.grey.shade100,
        ),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  Color? sideColor;
  Color? backgroundColor;
  Widget? child;
  double? width;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;

  CardContainer({this.sideColor, this.child, this.width, this.padding, this.margin, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: sideColor ?? Theme.of(context).primaryColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), offset: const Offset(-2, 0), blurRadius: 15),
            BoxShadow(color: Colors.red, offset: const Offset(0, 0), blurRadius: 0)]
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(10),
        margin: margin ?? EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor ?? Theme.of(context).cardColor,
        ),
        child: child,
      ),
    );
  }
}

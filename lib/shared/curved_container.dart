import 'package:flutter/material.dart';

class CustomCurvedContainer extends StatelessWidget {
  final Color? fillColor;
  final Color? borderColor;
  final Widget? child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const CustomCurvedContainer({
    super.key,
    this.fillColor,
    this.borderColor,
    this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 16),
        ),
        border: Border.all(color: borderColor ?? Colors.teal, width: 1.5),
        color: fillColor ?? Colors.white,
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: child ?? const SizedBox(),
    );
  }
}

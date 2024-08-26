// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/shared/logger.dart';

class CustomButton extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final Color? borderColor;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.child,
    this.color,
    this.onPressed,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () {
            logger.i('Custom Button pressed');
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: width ?? screenWidth(context) * 0.75,
        height: height ?? 49,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: color ?? Colors.teal,
          border: Border.all(
            width: 1,
            color: borderColor ?? Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        child: Center(child: child ?? const SizedBox()),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle headerStyle({Color? color, double? fontSize}) => TextStyle(
        fontSize: fontSize ?? 18,
        color: color ?? Colors.white,
        fontWeight: FontWeight.w600,
      );
  static TextStyle regularStyle({Color? color, double? fontSize}) => TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? Colors.black,
        fontWeight: FontWeight.w500,
      );
  static TextStyle lightStyle({Color? color, double? fontSize}) => TextStyle(
        fontSize: fontSize ?? 12,
        color: color ?? Colors.black,
        fontWeight: FontWeight.w400,
      );
}

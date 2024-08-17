import 'package:flutter/cupertino.dart';

class ScreenSize {
  double width;
  double height;

  ScreenSize(this.height, this.width);
}

ScreenSize screenSize(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  final totalWidth = size.width;
  final totalHeight = size.height;
  ScreenSize thisSize = ScreenSize(totalHeight, totalWidth);
  return thisSize;
}

double screenWidth(BuildContext context) {
  return screenSize(context).width;
}

double screenHeight(BuildContext context) {
  return screenSize(context).height;
}

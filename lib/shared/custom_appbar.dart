import 'package:flutter/material.dart';
import 'package:pharmko/components/appstyles.dart';

PreferredSizeWidget customAppbar(String titleTExt,
    {BuildContext? context,
    bool? showLeading = false,
    bool? showAcionIcon,
    List<Widget>? actions}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: showLeading == true
        ? Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 30,
              ),
            );
          })
        : const Icon(
            Icons.circle,
            color: Colors.white,
            size: 10,
          ),
    leadingWidth: 30,
    title: Text(
      titleTExt,
      style: AppStyles.headerStyle(),
    ),
    backgroundColor: Colors.teal,
    actions: actions,
  );
}

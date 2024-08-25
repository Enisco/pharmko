import 'package:flutter/material.dart';
import 'package:pharmko/components/appstyles.dart';

PreferredSizeWidget customAppbar(String titleTExt) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: Builder(builder: (context) {
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
    }),
    leadingWidth: 30,
    title: Text(
      titleTExt,
      style: AppStyles.headerStyle(),
    ),
    backgroundColor: Colors.teal,
  );
}

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
        : const Padding(
            padding: EdgeInsets.only(left: 14.0),
            child: Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 20,
            ),
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

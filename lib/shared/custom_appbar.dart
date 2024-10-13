import 'package:flutter/material.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/views/pharmacy_views/closed_tickets_view.dart';

PreferredSizeWidget customAppbar(String titleTExt,
    {BuildContext? context, bool? showLeading = false, bool? showActionIcon}) {
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
    actions: [
      showActionIcon == true
          ? IconButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => const ClosedTicketsListScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.recent_actors_outlined,
                color: Colors.white,
                size: 36,
              ),
            )
          : const SizedBox.shrink(),
    ],
  );
}

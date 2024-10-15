import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/views/medicine_store/stock_notification_screen.dart';

PreferredSizeWidget customAppbar(
  String titleTExt, {
  BuildContext? context,
  bool? showLeading = false,
  bool? showAcionIcon,
}) {
  final controller = Get.put(PharmacyStoreController());
  final totalNotifItems =
      controller.expiringSoonList.length + controller.lowStockList.length;

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
    actions: [
      GetBuilder<PharmacyStoreController>(
        init: PharmacyStoreController(),
        builder: (ctxt) {
          return SizedBox(
            width: 80,
            child: totalNotifItems > 0
                ? Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const StockNotificationsScreen(),
                          ),
                        );
                      },
                      icon: Badge(
                        label: Text('$totalNotifItems'),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    );
                  })
                : const SizedBox.shrink(),
          );
        },
      )
    ],
  );
}

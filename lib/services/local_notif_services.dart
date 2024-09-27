// ignore_for_file: unused_local_variable

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails('Test', 'myChannel',
          channelDescription: 'Pharmko',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  initializeNotificationServices() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
  }

  showNotification({required String title, required String message}) async {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, message, notificationDetails, payload: '');
  }
}

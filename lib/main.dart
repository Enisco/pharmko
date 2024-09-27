import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pharmko/controllers/main_controller.dart';
import 'package:pharmko/firebase_options.dart';
import 'package:pharmko/pharmko_app.dart';
import 'package:pharmko/services/local_notif_services.dart';
import 'package:pharmko/views/widgets/landing_page_options_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  currentUserRole = Roles.patient;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  LocalNotificationServices localNotificationServices =
      LocalNotificationServices();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  localNotificationServices.initializeNotificationServices();

  final controller = Get.put(MainController());
  controller.mqttConnect();

  runApp(const PharmkoApp());
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/controllers/main_controller.dart';
import 'package:pharmko/firebase_options.dart';
import 'package:pharmko/pharmko_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final controller = Get.put(MainController());
  controller.mqttConnect();

  runApp(const PharmkoApp());
}

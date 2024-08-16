import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/controllers/main_controller.dart';
import 'package:pharmko/pharmko_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final controller = Get.put(MainController());
  controller.mqttConnect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmko',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PharmkoApp(),
    );
  }
}

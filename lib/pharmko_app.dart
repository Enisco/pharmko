import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logger/logger.dart';
import 'package:pharmko/components/appstyles.dart';

var logger = Logger();

class PharmkoApp extends StatelessWidget {
  const PharmkoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AutoPond',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PharmkoLandingPage(),
    );
  }
}

class PharmkoLandingPage extends StatelessWidget {
  const PharmkoLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmko", style: AppStyles.headerStyle()),
        // backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.amber,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.add,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/views/widgets/landing_page_options_card.dart';

class PharmkoApp extends StatelessWidget {
  const PharmkoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pharmko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        primarySwatch: Colors.teal,
        useMaterial3: true,
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
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
        child: Center(
          child: Column(
            children: [
              Text(
                "Welcome to Pharmko",
                style: AppStyles.headerStyle(fontSize: 20, color: Colors.black),
              ),
              verticalSpacer(),
              Text(
                "Select a role to continue",
                style: AppStyles.lightStyle(color: Colors.teal.shade900),
              ),
              verticalSpacer(size: 20),
              landingPageOptionsCard(
                role: Roles.pharmacy,
                icon: Icons.local_pharmacy_rounded,
                iconColor: Colors.blue,
              ),
              landingPageOptionsCard(
                role: Roles.patient,
                icon: CupertinoIcons.person,
                iconColor: Colors.green.shade800,
              ),
              landingPageOptionsCard(
                role: Roles.rider,
                icon: Icons.pedal_bike,
                iconColor: Colors.orange.shade800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

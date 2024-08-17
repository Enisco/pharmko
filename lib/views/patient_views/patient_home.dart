import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/spacer.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmko", style: AppStyles.headerStyle()),
        backgroundColor: Colors.teal,
      ),
      body: Container(
          // color: Colors.amber,
          ),
      floatingActionButton: InkWell(
        onTap: () {},
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.teal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.add,
                color: Colors.white,
                size: 22,
              ),
              horizontalSpacer(size: 5),
              Text(
                "Create New Ticket",
                style: AppStyles.regularStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

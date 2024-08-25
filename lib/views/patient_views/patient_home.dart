import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/views/medicine_store/medicine_store_page.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar("Pharmko User"),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MedicineStorePage(),
            ),
          );
        },
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

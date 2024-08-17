import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/components/strings_helper.dart';
import 'package:pharmko/pharmko_app.dart';
import 'package:pharmko/views/patient_views/patient_home.dart';

enum Roles { pharmacy, patient, rider }

Widget landingPageOptionsCard({
  required Roles role,
  required IconData icon,
  Color? backgroundColor,
  required Color iconColor,
}) {
  return Builder(
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          elevation: 2,
          child: InkWell(
            onTap: () {
              Fluttertoast.showToast(msg: role.name.toSentenceCase());
              if (role == Roles.pharmacy) {
                logger.d("Pharmacy selected");
              } else if (role == Roles.patient) {
                logger.f("Patient selected");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientHomePage(),
                  ),
                );
              } else {
                logger.e("Rider selected");
              }
            },
            child: Container(
              height: 140,
              width: screenWidth(context) * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: backgroundColor ?? Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 55, color: iconColor),
                  verticalSpacer(),
                  Text(
                    role.name.toSentenceCase(),
                    style:
                        AppStyles.headerStyle(fontSize: 20, color: iconColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

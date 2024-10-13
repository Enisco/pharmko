import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/components/strings_helper.dart';
import 'package:pharmko/data/appdata.dart';
import 'package:pharmko/pharmko_app.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/views/patient_views/patient_home.dart';
import 'package:pharmko/views/pharmacy_views/pharmacy_home.dart';
import 'package:pharmko/views/rider_views/rider_home.dart';

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
              currentUserRole = role;
              logger.f("CurrentUserRole: $currentUserRole");
              if (role == Roles.pharmacy) {
                logger.d("Pharmacy selected");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PharmacyHomePage(),
                  ),
                );
              } else if (role == Roles.patient) {
                logger.f("Patient selected");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientHomePage(),
                  ),
                );
              } else {
                logger.i("Rider selected");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiderHomePage(),
                  ),
                );
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

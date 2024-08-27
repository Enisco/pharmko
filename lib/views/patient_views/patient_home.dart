import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/patient_controller.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/views/medicine_store/medicine_store_page.dart';
import 'package:pharmko/views/ticket_view.dart';

class PatientHomePage extends StatelessWidget {
  PatientHomePage({super.key});
  final controller = Get.put(PatientController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(
        init: PatientController(),
        initState: (state) => controller.refreshTicketData(),
        builder: (ctxt) {
          return Scaffold(
            appBar: customAppbar("Pharmko User"),
            body: controller.activeTicket == null
                ? Center(
                    child: Text(
                      "No active ticket",
                      style: AppStyles.regularStyle(),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ActiveTicketWidget(
                      ticketData: controller.activeTicket!,
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
        });
  }
}

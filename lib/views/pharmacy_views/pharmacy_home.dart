import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/controllers/pharmacy_controller.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/views/widgets/active_ticket_view.dart';

class PharmacyHomePage extends StatelessWidget {
  PharmacyHomePage({super.key});
  final controller = Get.put(PharmacyController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyController>(
      init: PharmacyController(),
      initState: (state) => controller.refreshTicketData(),
      builder: (ctxt) {
        return Scaffold(
          appBar: customAppbar(
            "Pharmko Pharmacy",
            showActionIcon: true,
            context: context,
          ),
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
        );
      },
    );
  }
}

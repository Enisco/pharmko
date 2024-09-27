// ignore_for_file: prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/rider_controller.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/shared/curved_container.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/views/maps_view/viewers_map.dart';

class RiderHomePage extends StatelessWidget {
  RiderHomePage({super.key});
  final controller = Get.put(RiderController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(
      init: RiderController(),
      initState: (state) {
        controller.refreshTicketData();
        controller.startLocationUpdates();
      },
      builder: (ctxt) {
        return Scaffold(
          appBar: customAppbar("Pharmko Rider"),
          body: controller.activeTicket == null
              ? Center(
                  child: Text(
                    "No active ticket",
                    style: AppStyles.regularStyle(),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      _detailsCard(controller.activeTicket!),
                    ],
                  ),
                ),
          floatingActionButton: controller.activeTicket == null
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewersMapView(
                          start: LatLng(
                              controller.activeTicket!.deliverer!.latitude!,
                              controller.activeTicket!.deliverer!.longitude!),
                          destination: LatLng(
                              controller.activeTicket!.buyer!.latitude!,
                              controller.activeTicket!.buyer!.longitude!),
                        ),
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
                          CupertinoIcons.map_pin_ellipse,
                          color: Colors.white,
                          size: 22,
                        ),
                        horizontalSpacer(size: 5),
                        Text(
                          "View Map",
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
      },
    );
  }

  Widget _detailsCard(OrderTicketModel ticket) {
    return CustomCurvedContainer(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Details",
            style: AppStyles.headerStyle(color: Colors.teal, fontSize: 16),
          ),
          verticalSpacer(size: 8),
          Row(
            children: [
              Text("Buyer's Name: ", style: AppStyles.lightStyle(fontSize: 14)),
              Text(ticket.buyer?.name ?? '', style: AppStyles.regularStyle()),
            ],
          ),
          verticalSpacer(size: 3),
          Row(
            children: [
              Text("Buyer's Phone Number: ",
                  style: AppStyles.lightStyle(fontSize: 14)),
              Text(ticket.buyer?.phoneNumber ?? '',
                  style: AppStyles.regularStyle()),
            ],
          ),
          Row(
            children: [
              Text("No of items: ", style: AppStyles.lightStyle(fontSize: 14)),
              Text(
                (ticket.medications?.length ?? 1).toString(),
                style: AppStyles.regularStyle(),
              ),
            ],
          ),
          verticalSpacer(size: 3),
        ],
      ),
    );
  }
}

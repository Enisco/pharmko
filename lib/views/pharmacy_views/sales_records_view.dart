import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/strings_helper.dart';
import 'package:pharmko/controllers/pharmacy_controller.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/views/widgets/active_ticket_view.dart';

class SalesRecordsScreen extends StatefulWidget {
  const SalesRecordsScreen({super.key});

  @override
  State<SalesRecordsScreen> createState() => _SalesRecordsScreenState();
}

class _SalesRecordsScreenState extends State<SalesRecordsScreen> {
  final controller = Get.put(PharmacyController());

  @override
  void initState() {
    super.initState();
    controller.fetchAllClosedTickets();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyController>(
      init: PharmacyController(),
      builder: (ctxt) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: customAppbar("Sales Records"),
          body: Column(
            children: [
              controller.loading == true
                  ? const SizedBox()
                  : Container(
                      width: screenWidth(context),
                      height: 80,
                      color: Colors.teal,
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Total sales for today (₦)",
                                  style: AppStyles.lightStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  controller.todayTotal.toCommaSeparated(),
                                  style: AppStyles.regularStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Total sales for this month (₦)",
                                  style: AppStyles.lightStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  // controller.monthTotal.toStringAsFixed(2),
                                  controller.monthTotal.toCommaSeparated(),
                                  style: AppStyles.regularStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              controller.loading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.closedTicketsList?.isNotEmpty == true
                      ? Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: controller.closedTicketsList?.length,
                            itemBuilder: (context, index) {
                              return _closedTicketCard(
                                controller.closedTicketsList![index]!,
                              );
                            },
                          ),
                        )
                      : const Text("No records yet"),
            ],
          ),
        );
      },
    );
  }

  Widget _closedTicketCard(OrderTicketModel ticket) {
    return InkWell(
      onTap: () {
        if (ticket.isWalkInSales == true) {
          logger.w("Do nothing");
        } else {
          logger.w("Clicked ${ticket.buyer?.name} ticket");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClosedTicketsView(ticket: ticket),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        height: 75,
        width: screenWidth(context),
        decoration: BoxDecoration(
          color: ticket.isWalkInSales == true
              ? Colors.grey.withOpacity(0.15)
              : Colors.white,
          border: Border.all(
            color: Colors.grey
                .withOpacity(ticket.isWalkInSales == true ? 0.8 : 0.15),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.buyer?.name ?? 'Walk-In Customer',
                  style: AppStyles.regularStyle(
                      fontSize: 17,
                      color: ticket.isWalkInSales == true
                          ? Colors.grey
                          : Colors.teal.shade900),
                ),
                Text(
                  DateFormat('MMMM d, yyyy, h:mm a').format(
                    ticket.timeCreated ?? DateTime.now(),
                  ),
                  style: AppStyles.lightStyle(),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₦${((ticket.payment?.amount ?? 0)).toStringAsFixed(2)}",
                  style: AppStyles.regularStyle(fontSize: 14),
                ),
                Text(
                  "${ticket.medications?.length} items",
                  style: AppStyles.regularStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClosedTicketsView extends StatelessWidget {
  final OrderTicketModel ticket;
  const ClosedTicketsView({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(ticket.buyer?.name ?? '', showLeading: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ActiveTicketWidget(
          ticketData: ticket,
        ),
      ),
    );
  }
}

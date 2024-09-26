import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/controllers/pharmacy_controller.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/views/widgets/active_ticket_view.dart';

class ClosedTicketsListScreen extends StatefulWidget {
  const ClosedTicketsListScreen({super.key});

  @override
  State<ClosedTicketsListScreen> createState() =>
      _ClosedTicketsListScreenState();
}

class _ClosedTicketsListScreenState extends State<ClosedTicketsListScreen> {
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
          appBar: customAppbar("Transaction Records"),
          body: Column(
            children: [
              controller.loading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.closedTicketsList?.isNotEmpty == true
                      ? Expanded(
                          child: ListView.builder(
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
        logger.w("Clicked ${ticket.buyer?.name} ticket");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClosedTicketsView(ticket: ticket),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        height: 60,
        width: screenWidth(context),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.buyer?.name ?? '',
              style: AppStyles.regularStyle(
                  fontSize: 17, color: Colors.teal.shade900),
            ),
            Text(
              DateFormat('MMMM d, yyyy').format(
                ticket.timeCreated ?? DateTime.now(),
              ),
              style: AppStyles.lightStyle(),
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
      appBar: customAppbar(ticket.buyer?.name ?? ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ActiveTicketWidget(
          ticketData: ticket,
        ),
      ),
    );
  }
}

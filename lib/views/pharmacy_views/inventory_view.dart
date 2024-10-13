import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/views/widgets/active_ticket_view.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final controller = Get.put(PharmacyStoreController());

  @override
  void initState() {
    super.initState();
    controller.getMedicineList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
      init: PharmacyStoreController(),
      builder: (ctxt) {
        return Scaffold(
          // backgroundColor: Colors.white,
          appBar: customAppbar("Inventory"),
          body: Column(
            children: [
              controller.loading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.medicineList.isNotEmpty == true
                      ? Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: controller.medicineList.length,
                            itemBuilder: (context, index) {
                              return inventoryCard(
                                controller.medicineList[index]!,
                              );
                            },
                          ),
                        )
                      : const Text("No records yet"),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: InkWell(
            onTap: () {
              // TODO: Add medicine to inventory screen here
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const AddMedicinePage(),
              //   ),
              // );
            },
            child: Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.teal,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                  horizontalSpacer(size: 5),
                  Text(
                    "Add to\nstore",
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

  Widget inventoryCard(MedicineModel medicineItem) {
    return InkWell(
      onTap: () {
        // TODO: Go to med details screen
        // logger.w("Clicked ${ticket.buyer?.name} ticket");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ClosedTicketsView(ticket: ticket),
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        height: 75,
        width: screenWidth(context),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  medicineItem.name ?? '',
                  style: AppStyles.regularStyle(fontSize: 17),
                ),
                Row(
                  children: [
                    Text(
                      "Qty Rem: ",
                      style: AppStyles.regularStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "${(medicineItem.itemsRemaining ?? 0)}",
                      style: AppStyles.regularStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₦${(medicineItem.amount ?? 0).toStringAsFixed(2)}",
                  style: AppStyles.lightStyle(),
                ),
                //
                Row(
                  children: [
                    Text(
                      "Exp. Date: ",
                      style: AppStyles.lightStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy, h:mm a').format(
                        medicineItem.expiryDate ?? DateTime.now(),
                      ),
                      style: AppStyles.lightStyle(fontSize: 14),
                    ),
                  ],
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

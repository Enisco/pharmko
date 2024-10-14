import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/views/medicine_store/add_new_med_page.dart';
import 'package:pharmko/views/medicine_store/inventory_med_details_page.dart';

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
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 90),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewMedicinePage(),
                ),
              );
            },
            child: Container(
              width: 140,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.teal, width: 2.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.teal,
                    size: 22,
                  ),
                  horizontalSpacer(size: 2),
                  Text(
                    "Add to store",
                    style: AppStyles.regularStyle(
                      color: Colors.teal,
                      fontSize: 16,
                    ).copyWith(height: 1),
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
        logger.w("Clicked ${medicineItem.name}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InventoryMedicineItemDetailsScreen(
              medicine: medicineItem,
            ),
          ),
        );
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
                      style: AppStyles.lightStyle(
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

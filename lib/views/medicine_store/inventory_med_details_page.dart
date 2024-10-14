// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/custom_textfield.dart';
import 'package:pharmko/shared/logger.dart';

class InventoryMedicineItemDetailsScreen extends StatefulWidget {
  final MedicineModel medicine;

  const InventoryMedicineItemDetailsScreen({super.key, required this.medicine});

  @override
  State<InventoryMedicineItemDetailsScreen> createState() =>
      _InventoryMedicineItemDetailsScreenState();
}

class _InventoryMedicineItemDetailsScreenState
    extends State<InventoryMedicineItemDetailsScreen> {
  final controller = Get.put(PharmacyStoreController());
  final additionalItemsQtyController = TextEditingController();
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: (widget.medicine.amount ?? 0).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(widget.medicine.name ?? '', showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailsCard("Name:", widget.medicine.name ?? ''),
              verticalSpacer(size: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description:",
                    style: AppStyles.headerStyle(color: Colors.black),
                  ),
                  horizontalSpacer(size: 8),
                  Text(
                    widget.medicine.description ?? 'No description',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              verticalSpacer(size: 12),
              _detailsCard(
                  "Amount", '₦${widget.medicine.amount?.toStringAsFixed(2)}'),
              CustomTextField(
                textEditingController: amountController,
                labelText: "Change amount",
                hintText: "Edit amount",
                keyboardType: TextInputType.number,
              ),
              verticalSpacer(size: 12),
              _detailsCard(
                "Expiry Date:",
                widget.medicine.expiryDate
                        ?.toLocal()
                        .toString()
                        .split(' ')[0] ??
                    DateTime.now()
                        .add(const Duration(days: 150))
                        .toLocal()
                        .toString()
                        .split(' ')[0],
              ),
              _detailsCard(
                  "Dosage:", widget.medicine.dosage ?? 'Ask physician'),
              verticalSpacer(size: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Caution:",
                    style: AppStyles.headerStyle(color: Colors.black),
                  ),
                  horizontalSpacer(size: 8),
                  Text(
                    '${widget.medicine.caution}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              verticalSpacer(size: 30),
              (widget.medicine.itemsRemaining ?? 0) <= 0
                  ? Center(
                      child: Text(
                        'Out of stock',
                        style: TextStyle(
                            fontSize: 13, color: Colors.orange.shade800),
                      ),
                    )
                  : Row(
                      children: [
                        Text(
                          "Remaining Quantity: ",
                          style: AppStyles.regularStyle(fontSize: 16),
                        ),
                        horizontalSpacer(size: 8),
                        Text(
                          ' ${widget.medicine.itemsRemaining}',
                          style: AppStyles.headerStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
              verticalSpacer(size: 5),
              verticalSpacer(size: 10),
              CustomTextField(
                textEditingController: additionalItemsQtyController,
                labelText: "Additional Quantity",
                hintText: "Enter additional quantity",
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (additionalItemsQtyController.text.trim().isNotEmpty == true) {
            final newQuantity = (widget.medicine.itemsRemaining ?? 0) +
                int.parse(additionalItemsQtyController.text.trim());
            widget.medicine.itemsRemaining = newQuantity;
            if (amountController.text.trim().isNotEmpty == true) {
              widget.medicine.amount =
                  double.parse(amountController.text.trim());
            }
            logger.f("Updated med data: ${widget.medicine.toJson()}");
            await FirebaseRepo()
                .updateIndividualMedicineInInventory(widget.medicine);
            Navigator.pop(context);
            Get.put(PharmacyStoreController()).getMedicineList();
          } else {
            Fluttertoast.showToast(msg: "Enter additional item quantity");
          }
        },
        child: Container(
          width: 200,
          height: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            color: Colors.teal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.add_circled,
                color: Colors.white,
                size: 22,
              ),
              horizontalSpacer(size: 5),
              Text(
                "Update",
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

  Widget _detailsCard(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Row(
        children: [
          Text(
            title,
            style: AppStyles.headerStyle(color: Colors.black),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

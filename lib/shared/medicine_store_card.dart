import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/views/medicine_store/medicine_details_page.dart';

class MedicineStoreCard extends StatefulWidget {
  final MedicineModel medicine;
  const MedicineStoreCard({super.key, required this.medicine});

  @override
  State<MedicineStoreCard> createState() => _MedicineStoreCardState();
}

class _MedicineStoreCardState extends State<MedicineStoreCard> {
  final controller = Get.put(PharmacyStoreController());
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
        init: PharmacyStoreController(),
        builder: (ctxt) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: SizedBox(
                height: 75,
                child: ListTile(
                  title: Text(
                    widget.medicine.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.regularStyle(fontSize: 16)
                        .copyWith(height: 2.2),
                  ),
                  subtitle: Text(
                    widget.medicine.description ?? 'No description',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    "₦${widget.medicine.amount?.toStringAsFixed(2)}",
                    style: AppStyles.lightStyle().copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MedicineDetailsScreen(medicine: widget.medicine),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}

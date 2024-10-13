import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/data/appdata.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/shared/medicine_store_card.dart';
import 'package:pharmko/views/medicine_store/cart_checkout_page.dart';

class MedicineStorePage extends StatefulWidget {
  const MedicineStorePage({super.key, required this.role});
  final Roles? role;

  @override
  State<MedicineStorePage> createState() => _MedicineStorePageState();
}

class _MedicineStorePageState extends State<MedicineStorePage> {
  final controller = Get.put(PharmacyStoreController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
      init: PharmacyStoreController(),
      initState: (state) => controller.getMedicineList(),
      builder: (ctxt) {
        return Scaffold(
          appBar: customAppbar("Pharmko Store"),
          body: Column(
            children: [
              controller.loading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.medicineList.length,
                        itemBuilder: (context, index) {
                          return MedicineStoreCard(
                            medicine: controller.medicineList[index]!,
                          );
                        },
                      ),
                    ),
            ],
          ),
          floatingActionButton: controller.cartMedicineList.isNotEmpty == true
              ? FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    logger.w("Go to Cart Checkout screen");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartCheckoutPage(
                          role: widget.role,
                        ),
                      ),
                    );
                  },
                  child: Badge.count(
                    count: controller.cartMedicineList.length,
                    isLabelVisible:
                        controller.cartMedicineList.isNotEmpty == true,
                    child: const Icon(
                      CupertinoIcons.cart_fill,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

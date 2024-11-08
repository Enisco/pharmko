import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/data/appdata.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/custom_textfield.dart';
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
  TextEditingController searchController = TextEditingController();
  String _previousText = "";

  void _handleTextChange(String currentText) {
    if ((_previousText.isEmpty && currentText.isNotEmpty) ||
        (_previousText.isNotEmpty && currentText.isEmpty)) {
      setState(() {
        _previousText = currentText;
      });
    } else {
      _previousText = currentText;
    }
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
      init: PharmacyStoreController(),
      initState: (state) => controller.getMedicineList(),
      builder: (ctxt) {
        List<MedicineModel?> medicineListToDisplay = [];
        medicineListToDisplay = controller.searchMedicineList.isNotEmpty == true
            ? controller.searchMedicineList
            : controller.medicineList;

        return Scaffold(
          appBar: customAppbar("Pharmko Store"),
          body: controller.loading == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        textEditingController: searchController,
                        hintText: "Search medication . . .",
                        hintStyle: AppStyles.lightStyle(),
                        suffix: searchController.text.trim().isNotEmpty == true
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    controller.searchMedicine('');
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                  });
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  size: 14,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                              )
                            : const SizedBox.shrink(),
                        onChanged: (txt) {
                          _handleTextChange(txt);
                          controller.searchMedicine(txt);
                        },
                      ),
                    ),
                    controller.searchMedicineList.isEmpty == true &&
                            searchController.text.trim().isNotEmpty == true
                        ? Text(
                            "No results for '${searchController.text.trim()}'")
                        : Expanded(
                            child: ListView.builder(
                              itemCount: medicineListToDisplay.length,
                              itemBuilder: (context, index) {
                                return MedicineStoreCard(
                                  medicine: medicineListToDisplay[index]!,
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

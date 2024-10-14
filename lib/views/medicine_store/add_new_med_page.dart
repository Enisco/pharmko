import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/custom_button.dart';
import 'package:pharmko/shared/custom_textfield.dart';
import 'package:pharmko/shared/logger.dart';

class AddNewMedicinePage extends StatefulWidget {
  const AddNewMedicinePage({super.key});

  @override
  State<AddNewMedicinePage> createState() => _AddNewMedicinePageState();
}

class _AddNewMedicinePageState extends State<AddNewMedicinePage> {
  final controller = Get.put(PharmacyStoreController());
  final medNameController = TextEditingController();
  final medDescriptionController = TextEditingController();
  final cautionController = TextEditingController();
  final dosageController = TextEditingController();
  final amountController = TextEditingController();
  final itemsQtyController = TextEditingController();
  final expDateController = TextEditingController();
  DateTime? selectedDate;
  bool uploading = false;

  void attemptToAddNewMedicine() async {
    if (medNameController.text.trim().isNotEmpty == true &&
        medDescriptionController.text.trim().isNotEmpty == true &&
        cautionController.text.trim().isNotEmpty == true &&
        dosageController.text.trim().isNotEmpty == true &&
        amountController.text.trim().isNotEmpty == true &&
        itemsQtyController.text.trim().isNotEmpty == true &&
        selectedDate != null) {
      setState(() {
        uploading = true;
      });
      final newMedicine = MedicineModel(
        id: generateRandomId(12),
        name: medNameController.text.trim(),
        description: medDescriptionController.text.trim(),
        amount: double.tryParse(amountController.text.trim()),
        expiryDate: selectedDate,
        dosage: dosageController.text.trim(),
        caution: cautionController.text.trim(),
        itemsRemaining: int.tryParse(itemsQtyController.text.trim()),
      );
      await FirebaseRepo().addMedicineToInventory(newMedicine);
      logger.f('Added medicine to Inventory successfully');
      Fluttertoast.showToast(
        msg: "Successfully added to the Inventory",
        backgroundColor: Colors.green,
      );
      clearTextfields();
      setState(() {
        uploading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Kindly fill all fields");
    }
  }

  clearTextfields() {
    medNameController.clear();
    medDescriptionController.clear();
    cautionController.clear();
    dosageController.clear();
    amountController.clear();
    expDateController.clear();
    itemsQtyController.clear();
    medNameController.clear();
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
      setState(() {
        selectedDate = pickedDate;
        expDateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
      init: PharmacyStoreController(),
      initState: (state) => controller.getMedicineList(),
      builder: (ctxt) {
        return Scaffold(
          appBar: customAppbar("Add New Medicine", showLeading: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Column(
              children: [
                verticalSpacer(size: 15),
                CustomTextField(
                  textEditingController: medNameController,
                  labelText: "Medication Name",
                  hintText: "Enter medication name",
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: medDescriptionController,
                  labelText: "Description",
                  hintText: "Enter description",
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: cautionController,
                  labelText: "Caution",
                  hintText: "Enter medication caution",
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: dosageController,
                  labelText: "Dosage",
                  hintText: "Enter medication dosage",
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: amountController,
                  labelText: "Amount",
                  hintText: "Enter medication cost",
                  keyboardType: TextInputType.number,
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: itemsQtyController,
                  labelText: "Quantity",
                  hintText: "Enter item quantity",
                  keyboardType: TextInputType.number,
                ),
                verticalSpacer(size: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      width: screenWidth(context) - 90,
                      textEditingController: expDateController,
                      labelText: "Expiry Date",
                      hintText: "Choose expiry date",
                      readOnly: true,
                      cursorColor: Colors.white,
                    ),
                    horizontalSpacer(),
                    IconButton(
                      onPressed: () {
                        logger.i("Pick expiry date");
                        selectDate(context);
                      },
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                        size: 33,
                      ),
                    ),
                  ],
                ),
                verticalSpacer(size: 10),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: uploading == true
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    onPressed: () {
                      logger.w('Save new med');
                      attemptToAddNewMedicine();
                    },
                    child: Text(
                      "Save",
                      style: AppStyles.regularStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

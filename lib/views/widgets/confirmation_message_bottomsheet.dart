import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/patient_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/shared/custom_button.dart';
import 'package:pharmko/shared/custom_textfield.dart';
import 'package:pharmko/shared/logger.dart';

showCreateTicketConfirmationSheet(
  BuildContext context, {
  required List<MedicineModel?> cartMedicineList,
  required double amountPaid,
}) {
  TextEditingController messageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool canPopCheck = false;
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return PopScope(
        canPop: canPopCheck,
        onPopInvokedWithResult: (didPop, result) {
          logger.w("Pop Result: $didPop - $result");
        },
        child: SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 15,
              bottom: 15,
            ),
            width: screenWidth(context),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Complete Your Order",
                  style: AppStyles.regularStyle(
                    fontSize: 22,
                    color: Colors.teal,
                  ),
                ),
                verticalSpacer(),
                Text(
                  "Kindly enter your details",
                  style: AppStyles.lightStyle(fontSize: 14),
                ),
                verticalSpacer(size: 35),
                CustomTextField(
                  textEditingController: nameController,
                  labelText: "Name",
                  hintText: "Enter your name",
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: emailController,
                  labelText: "Email",
                  hintText: "Enter your name",
                  keyboardType: TextInputType.emailAddress,
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: phoneController,
                  labelText: "Phone number",
                  hintText: "Enter your phone number",
                  keyboardType: TextInputType.number,
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: messageController,
                  labelText: "Additional Notes?",
                  hintText: "Any message for the pharmacy?",
                ),
                verticalSpacer(size: 35),
                CustomButton(
                  color: Colors.teal,
                  borderColor: Colors.white54,
                  height: 45,
                  borderRadius: 16,
                  width: screenWidth(context) * 0.5,
                  child: Text(
                    "Confirm",
                    style: AppStyles.regularStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty == true &&
                        phoneController.text.trim().isNotEmpty == true) {
                      final message = messageController.text.trim();
                      Buyer buyerData = Buyer(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phoneNumber: phoneController.text.trim());
                      Get.put(PatientController()).createNewTicket(
                        message: message,
                        buyerData: buyerData,
                        amountPaid: amountPaid,
                        cartMedicineList: cartMedicineList,
                      );
                      canPopCheck = true;
                      logger.w("popping");
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Name and phone number are needed");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

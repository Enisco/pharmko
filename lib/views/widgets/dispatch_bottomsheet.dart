import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/shared/custom_button.dart';
import 'package:pharmko/shared/custom_textfield.dart';
import 'package:pharmko/shared/logger.dart';

showAssignDispatcherSheet(BuildContext context, OrderTicketModel ticket) {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
                  "Assign a dispatcher",
                  style: AppStyles.regularStyle(
                    fontSize: 22,
                    color: Colors.teal,
                  ),
                ),
                verticalSpacer(),
                Text(
                  "Kindly enter the disptcher's details",
                  style: AppStyles.lightStyle(fontSize: 14),
                ),
                verticalSpacer(size: 35),
                CustomTextField(
                  textEditingController: nameController,
                  labelText: "Name",
                  hintText: "Enter disptcher's name",
                ),
                verticalSpacer(size: 10),
                CustomTextField(
                  textEditingController: phoneController,
                  labelText: "Phone number",
                  hintText: "Enter disptcher's phone number",
                  keyboardType: TextInputType.number,
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
                      Buyer delivererData = Buyer(
                        name: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),

                        /// Default Rider Destination
                        latitude: 7.292958,
                        longitude: 5.149895,
                      );
                      FirebaseRepo().updateTicket(ticket.copyWith(
                        deliverer: delivererData,
                        dispatched: true,
                        orderConfirmed: true,
                      ));
                      canPopCheck = true;
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

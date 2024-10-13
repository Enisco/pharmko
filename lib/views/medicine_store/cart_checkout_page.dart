// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/data/appdata.dart';
import 'package:pharmko/services/payment_service.dart';
import 'package:pharmko/shared/cart_checkout_card.dart';
import 'package:pharmko/shared/curved_container.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/custom_button.dart';
import 'package:pharmko/shared/logger.dart';

class CartCheckoutPage extends StatefulWidget {
  const CartCheckoutPage({super.key, required this.role});
  final Roles? role;

  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  final controller = Get.put(PharmacyStoreController());
  final paymentController = Get.put(PaymentGatewayService());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
      init: PharmacyStoreController(),
      builder: (ctxt) {
        return Scaffold(
          appBar: customAppbar("Cart"),
          body: Column(
            children: [
              controller.loading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.cartMedicineList.length,
                        itemBuilder: (context, index) {
                          return CartCheckoutCard(
                            medicine: controller.cartMedicineList[index]!,
                          );
                        },
                      ),
                    ),
            ],
          ),
          bottomNavigationBar: widget.role == Roles.patient
              ? controller.cartMedicineList.isNotEmpty == true
                  ? InkWell(
                      onTap: () {
                        logger.i(
                            "Checkout: Pay ₦${controller.totalCost.toStringAsFixed(2)})");
                        paymentController.initiateTransaction(
                          context,
                          amountToPay: controller.totalCost,
                          cartMedicineList: controller.cartMedicineList,
                        );
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
                              CupertinoIcons.cart_badge_plus,
                              color: Colors.white,
                              size: 22,
                            ),
                            horizontalSpacer(size: 5),
                            Text(
                              "Checkout (${controller.cartMedicineList.length} items, ₦${controller.totalCost.toStringAsFixed(2)})",
                              style: AppStyles.regularStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
              : salesConfirmationCard(controller),
        );
      },
    );
  }

  Widget salesConfirmationCard(PharmacyStoreController controller) {
    if (controller.loading == true || controller.totalCost <= 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            horizontalSpacer(size: 5),
            Text(
              "Total: ${controller.cartMedicineList.length} items, ₦${controller.totalCost.toStringAsFixed(2)}",
              style: AppStyles.regularStyle(fontSize: 18),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showCancelSalesConfirmationSheet();
                  },
                  child: CustomCurvedContainer(
                    width: screenWidth(context) * 0.42,
                    height: 50,
                    fillColor: Colors.white,
                    borderColor: Colors.teal,
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: AppStyles.regularStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    logger.f('Confirm Sales');
                    await controller.createSalesTicket(
                      controller.totalCost,
                      controller.cartMedicineList,
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: CustomCurvedContainer(
                    width: screenWidth(context) * 0.42,
                    height: 50,
                    fillColor: Colors.teal,
                    borderColor: Colors.teal,
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: AppStyles.regularStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  showCancelSalesConfirmationSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
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
                  "Are you sure you want to cancel this sales?",
                  style: AppStyles.regularStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                verticalSpacer(size: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      color: Colors.white,
                      borderColor: Colors.grey,
                      height: 45,
                      borderRadius: 16,
                      width: screenWidth(context) * 0.45,
                      child: Text(
                        "Cancel",
                        style: AppStyles.regularStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        logger.w('Cancel Sales');
                        controller.resetTicketCreationData();
                        Fluttertoast.showToast(msg: "Sales canceled");
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    CustomButton(
                      color: Colors.white,
                      borderColor: Colors.teal,
                      height: 45,
                      borderRadius: 16,
                      width: screenWidth(context) * 0.45,
                      child: Text(
                        "Go back",
                        style: AppStyles.regularStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                verticalSpacer(size: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}

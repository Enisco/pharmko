import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/services/payment_service.dart';
import 'package:pharmko/shared/cart_checkout_card.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/logger.dart';

class CartCheckoutPage extends StatefulWidget {
  const CartCheckoutPage({super.key});

  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  final controller = Get.put(PharmacyStoreController());
  final paymentController = Get.put(PaymentService());

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
          bottomNavigationBar: controller.cartMedicineList.isNotEmpty == true
              ? InkWell(
                  onTap: () {
                    logger.i(
                        "Checkout: Pay ₦${controller.totalCost.toStringAsFixed(2)})");
                    paymentController.initiateTransaction(
                      context,
                      controller.totalCost,
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
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

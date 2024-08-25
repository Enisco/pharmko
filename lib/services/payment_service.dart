import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/shared/logger.dart';

class PaymentService extends PharmacyStoreController {
  bool? transactionSuccessful;
  initiateTransaction(BuildContext context, double amountToPay) async {
    load();
    final uniqueTransRef = PayWithPayStack().generateUuidV4();

    logger.f("Paying ₦${amountToPay.toStringAsFixed(2)})");

    PayWithPayStack().now(
      context: context,
      secretKey: "sk_test_1072024c6d345a86debb59a0ba1793e3422a26d1",
      customerEmail: "sodeeqe03@gmail.com",
      reference: uniqueTransRef,
      callbackUrl: "setup in your paystack dashboard",
      currency: "NGN",
      paymentChannel: ["ussd", "card"],
      amount: amountToPay,
      transactionCompleted: () {
        logger.f("Transaction Successful");
        transactionSuccessful = true;
      },
      transactionNotCompleted: () {
        logger.w("Transaction Not Successful!");
        transactionSuccessful = false;
      },
    );

    stopLoading();
  }
}

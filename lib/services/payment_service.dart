// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/views/widgets/confirmation_message_bottomsheet.dart';

class PaymentGatewayService extends PharmacyStoreController {
  initiateTransaction(
    BuildContext context, {
    required double amountToPay,
    required List<MedicineModel?> cartMedicineList,
  }) async {
    const secretKey = 'sk_test_1072024c6d345a86debb59a0ba1793e3422a26d1';

    final amountInKobo = double.parse(amountToPay.toStringAsFixed(2)) * 100;

    logger.f("Paying $amountInKobo in Kobo");

    try {
      final request = PaystackTransactionRequest(
        reference: 'pharmko_${DateTime.now().microsecondsSinceEpoch}',
        secretKey: secretKey,
        email: 'sodeeqe03@gmail.com',
        amount: amountInKobo,
        currency: PaystackCurrency.ngn,
        channel: [
          PaystackPaymentChannel.card,
          PaystackPaymentChannel.ussd,
          PaystackPaymentChannel.bankTransfer,
          PaystackPaymentChannel.bank,
        ],
      );

      final transactionRes =
          await PaymentService.initializeTransaction(request);
      logger.f("transaction Response: ${transactionRes.toJson()}");

      if (!transactionRes.status) {
        Fluttertoast.showToast(
          msg: transactionRes.message,
          backgroundColor: Colors.red,
        );
        return null;
      }

      final paymentResponse = await PaymentService.showPaymentModal(
        context,
        transaction: transactionRes,
        callbackUrl: 'example.com',
      ).then((_) async {
        final verificationRes = await PaymentService.verifyTransaction(
          paystackSecretKey: secretKey,
          transactionRes.data?.reference ?? request.reference,
        );
        logger.i("verification Response: ${verificationRes.toJson()}");
        return verificationRes;
      });

      logger.f("Payment Response: ${paymentResponse.toJson()}");
      if (paymentResponse.data.status == PaystackTransactionStatus.success) {
        Fluttertoast.showToast(
          msg: "Payment Successful",
          textColor: Colors.green,
        );
        logger.f("Payment successful");
        showCreateTicketConfirmationSheet(
          context,
          cartMedicineList: cartMedicineList,
          amountPaid: amountInKobo,
        );
      }
      stopLoading();
    } catch (e) {
      logger.e("Error occured: ${e.toString()}");
    }
  }
}

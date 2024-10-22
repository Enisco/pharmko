import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/shared/custom_appbar.dart';
import 'package:pharmko/shared/logger.dart';

class StoreMedicineDetailsScreen extends StatefulWidget {
  final MedicineModel medicine;

  const StoreMedicineDetailsScreen({super.key, required this.medicine});

  @override
  State<StoreMedicineDetailsScreen> createState() =>
      _StoreMedicineDetailsScreenState();
}

class _StoreMedicineDetailsScreenState
    extends State<StoreMedicineDetailsScreen> {
  final controller = Get.put(PharmacyStoreController());
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      if (_quantity < (widget.medicine.itemsRemaining ?? 0)) {
        _quantity++;
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  DateTime threeMonthsFromNow = DateTime.now().add(const Duration(days: 90));
  bool expiringSoon(DateTime expiryDate) {
    if (expiryDate.isBefore(threeMonthsFromNow)) {
      return true;
    } else {
      return false;
    }
  }

  int daysFromNow(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    return difference.inDays.abs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(widget.medicine.name ?? '', showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailsCard("Name:", widget.medicine.name ?? ''),
            verticalSpacer(size: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description:",
                  style: AppStyles.headerStyle(color: Colors.black),
                ),
                horizontalSpacer(size: 8),
                Text(
                  widget.medicine.description ?? 'No description',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            verticalSpacer(size: 12),
            _detailsCard(
                "Amount:", '₦${widget.medicine.amount?.toStringAsFixed(2)}'),
            _detailsCard(
              "Expiry Date:",
              widget.medicine.expiryDate?.toLocal().toString().split(' ')[0] ??
                  DateTime.now()
                      .add(const Duration(days: 150))
                      .toLocal()
                      .toString()
                      .split(' ')[0],
            ),
            _detailsCard("Dosage:", widget.medicine.dosage ?? 'Ask physician'),
            verticalSpacer(size: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Caution:",
                  style: AppStyles.headerStyle(color: Colors.black),
                ),
                horizontalSpacer(size: 8),
                Text(
                  '${widget.medicine.caution}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            verticalSpacer(size: 30),
            (widget.medicine.itemsRemaining ?? 0) <= 0
                ? Center(
                    child: Text(
                      'Out of stock',
                      style: TextStyle(
                          fontSize: 13, color: Colors.orange.shade800),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Quantity:",
                        style: AppStyles.headerStyle(color: Colors.black),
                      ),
                      horizontalSpacer(size: 8),
                      _quantityCounter(),
                    ],
                  ),
            verticalSpacer(size: 5),
            (widget.medicine.itemsRemaining ?? 0) <= 0
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ' ${widget.medicine.itemsRemaining} items remaining',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: (widget.medicine.itemsRemaining ?? 0) <= 0
          ? const SizedBox.shrink()
          : SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  expiringSoon(widget.medicine.expiryDate ?? DateTime.now())
                      ? Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.amber),
                          ),
                          width: screenWidth(context),
                          child: Center(
                            child: Text(
                              "Expiring in ${daysFromNow(widget.medicine.expiryDate ?? DateTime.now())} days",
                              style: AppStyles.regularStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  InkWell(
                    onTap: () {
                      final medicineToCart = widget.medicine;
                      medicineToCart.orderQuantity = _quantity;
                      logger.f("medicineToCart: ${medicineToCart.toJson()}");
                      controller.updateCartItems(medicineToCart);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: screenWidth(context),
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
                            "Add to Cart",
                            style: AppStyles.regularStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _quantityCounter() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey[200],
              child: const Icon(Icons.remove),
            ),
            onPressed: _decrementQuantity,
          ),
          horizontalSpacer(size: 15),
          Text(
            _quantity.toString(),
            style: const TextStyle(fontSize: 18),
          ),
          horizontalSpacer(size: 15),
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey[200],
              child: const Icon(Icons.add),
            ),
            onPressed: _incrementQuantity,
          ),
        ],
      ),
    );
  }

  Widget _detailsCard(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.headerStyle(color: Colors.black),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

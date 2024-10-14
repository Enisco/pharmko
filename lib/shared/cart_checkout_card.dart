import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/views/medicine_store/medicine_details_page.dart';

class CartCheckoutCard extends StatefulWidget {
  final MedicineModel medicine;
  const CartCheckoutCard({super.key, required this.medicine});

  @override
  State<CartCheckoutCard> createState() => _CartCheckoutCardState();
}

class _CartCheckoutCardState extends State<CartCheckoutCard> {
  final controller = Get.put(PharmacyStoreController());
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
      init: PharmacyStoreController(),
      builder: (ctxt) {
        return Container(
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.tealAccent),
              borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StoreMedicineDetailsScreen(medicine: widget.medicine),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: screenWidth(context),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.medicine.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.regularStyle(fontSize: 16)
                              .copyWith(height: 2.2),
                        ),
                        Text(
                          "₦${widget.medicine.amount?.toStringAsFixed(2)}",
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.lightStyle().copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Qty: ${widget.medicine.orderQuantity}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton(
                    onPressed: () {
                      controller.removeFromCart(widget.medicine);
                    },
                    icon: const Icon(
                      CupertinoIcons.delete,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

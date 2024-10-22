import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmko/controllers/patient_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/shared/logger.dart';

class PharmacyStoreController extends GetxController {
  List<MedicineModel?> cartMedicineList = [], medicineList = [];
  List<MedicineModel?> expiringSoonList = [], lowStockList = [];
  bool loading = false;
  double totalCost = 0.0;

  resetTicketCreationData() {
    totalCost = 0.0;
    cartMedicineList.clear();
    medicineList.clear();
    update();
    stopLoading();
    logger.w("Reset data: ${cartMedicineList.length}, $totalCost");
  }

  getMedicineList() async {
    loading = true;
    medicineList = await FirebaseRepo().fecthMedicinesInventory();
    medicineList.sort((a, b) => (a?.name ?? '').compareTo(b?.name ?? ''));
    stopLoading();
    updateController();
    filterMedicines(medicineList);
  }

  filterMedicines(List<MedicineModel?> medicineList) {
    DateTime currentDate = DateTime.now();
    DateTime threeMonthsFromNow = currentDate.add(const Duration(days: 90));
    expiringSoonList = [];
    lowStockList = [];

    for (var medicine in medicineList) {
      if ((medicine?.expiryDate ?? DateTime.now().add(const Duration(days: 24)))
          .isBefore(threeMonthsFromNow)) {
        expiringSoonList.add(medicine);
      }

      if ((medicine?.itemsRemaining ?? 0) <= 20) {
        lowStockList.add(medicine);
      }
    }
    logger.w(
        "expiringSoonList: ${expiringSoonList.length}, lowStockList: ${lowStockList.length}");

    updateController();
  }

  void updateCartItems(MedicineModel medicine) {
    final existingMedicine = cartMedicineList.firstWhere(
        (element) => element?.name == medicine.name,
        orElse: () => null);

    if (existingMedicine == null) {
      cartMedicineList.add(medicine);
    } else {
      existingMedicine.orderQuantity =
          (existingMedicine.orderQuantity ?? 1) + (medicine.orderQuantity ?? 1);
    }
    update();
    calculateTotalCost();
  }

  void removeFromCart(MedicineModel medicine) {
    cartMedicineList.removeWhere((element) => element?.name == medicine.name);
    update();
    calculateTotalCost();
  }

  calculateTotalCost() {
    totalCost = 0.0;
    for (final medicine in cartMedicineList) {
      totalCost += (medicine?.orderQuantity ?? 1) * (medicine?.amount ?? 1);
    }
    logger.f("Total cost: $totalCost");
    update();
  }

  Future<void> createSalesTicket(
      double amountPaid, List<MedicineModel?> cartMedicineList) async {
    load();
    // Create sales ticket
    OrderTicketModel salesTicket = OrderTicketModel(
      ticketId: generateRandomString(),
      medications: cartMedicineList,
      payment: Payment(amount: amountPaid, paid: true),
      timeCreated: DateTime.now(),
    );
    logger.f("Sales ticket: ${salesTicket.toJson()}");
    await FirebaseRepo().saveSalesTicket(salesTicket);

    // Update Inventory
    await FirebaseRepo().updateInventory(cartMedicineList, medicineList);
    stopLoading();
    Get.put(PharmacyStoreController()).resetTicketCreationData();
    Fluttertoast.showToast(msg: "Inventory Updated Successfully");
  }

  load() {
    loading = true;
    logger.i("Loading . . . ");
    update();
  }

  stopLoading() {
    loading = false;
    logger.i("Done loading!");
    update();
  }

  updateController() {
    update();
  }
}

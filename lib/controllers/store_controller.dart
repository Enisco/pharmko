import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:pharmko/controllers/patient_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/shared/logger.dart';

class PharmacyStoreController extends GetxController {
  List<MedicineModel?> cartMedicineList = [], medicineList = [];
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

  void createSalesTicket(
      double amountPaid, List<MedicineModel?> cartMedicineList) {
    // Create sales ticket
    Get.put(PatientController()).createNewTicket(
      message: '',
      buyerData: Buyer(),
      amountPaid: amountPaid,
      cartMedicineList: cartMedicineList,
    );

    // Update Inventory
    FirebaseRepo().updateInventory(cartMedicineList);
  }

  Future<void> addMedicineToInventoryList(MedicineModel newMedicine) async {
    logger.w("Uploading medicines");
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child("inventory");
    await databaseRef.push().set(newMedicine.toJson());
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

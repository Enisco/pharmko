import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pharmko/data/medicine_list_data.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/shared/logger.dart';

class PharmacyStoreController extends GetxController {
  List<MedicineModel> cartMedicineList = [], medicineList = [];
  bool loading = false;

  getMedicineList() {
    medicineList = parseMedicineList(jsonEncode(medicineListJson));
    updateController();
  }

  List<MedicineModel> parseMedicineList(String jsonString) {
    load();
    List<MedicineModel> parsedMedicineList = [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      parsedMedicineList =
          jsonList.map((json) => MedicineModel.fromJson(json)).toList();
      parsedMedicineList.sort((a, b) => a.name.compareTo(b.name));
      logger.f("Last Medicine: ${parsedMedicineList.last.toJson()}");
    } catch (e) {
      logger.w("Error occured");
    }
    stopLoading();
    return parsedMedicineList;
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

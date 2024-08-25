import 'dart:convert';

import 'package:pharmko/controllers/main_controller.dart';
import 'package:pharmko/data/medicine_list_data.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/shared/logger.dart';

class PharmacyController extends MainController {
  List<MedicineModel>? medicineList = [];
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
    } catch (e) {
      logger.w("Error occured");
    }
    stopLoading();
    return parsedMedicineList;
  }

  load() {
    loading = true;
    update();
  }

  stopLoading() {
    loading = false;
    update();
  }

  updateController() {
    update();
  }
}

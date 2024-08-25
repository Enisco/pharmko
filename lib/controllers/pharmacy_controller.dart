import 'package:pharmko/controllers/main_controller.dart';
import 'package:pharmko/models/medicine_model.dart';

class PharmacyController extends MainController {
  List<MedicineModel>? medicineList = [];
  bool loading = false;

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

import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmko/pharmko_app.dart';

class FirebaseRepo {
  Future<void> refreshData() async {
    // final accessDataRef = FirebaseDatabase.instance.ref("access_data");

    // accessDataRef.onChildAdded.listen(
    //   (event) {
    //     AccessDataModel retrievedAccessData = accessDataModelFromJson(
    //         jsonEncode(event.snapshot.value).toString());
    //     logger.d("Going again");
    //     return retrievedAccessData;
    //   },
    // );
  }

  updateAccessData(updatedAccessData) async {
    try {
      String rfId = updatedAccessData.id!;

      DatabaseReference ref =
          FirebaseDatabase.instance.ref("access_data/$rfId");

      logger.f(updatedAccessData.toJson());

      await ref.update(updatedAccessData.toJson()).whenComplete(() async {
        logger.d("Data updated");
        Fluttertoast.showToast(msg: "Data updated");
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

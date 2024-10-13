import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmko/data/medicine_list_data.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/services/location_service.dart';
import 'package:pharmko/services/viewers_map_service.dart';
import 'package:pharmko/shared/logger.dart';

class PharmacyController extends GetxController {
  OrderTicketModel? activeTicket;
  List<OrderTicketModel?>? closedTicketsList;

  bool loading = false;

  refreshTicketData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("ActiveTickets");
      ref.onValue.listen((event) {
        if (event.snapshot.exists) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(event.snapshot.value as Map);
          OrderTicketModel ticket = orderTicketModelFromJson(jsonEncode(data));
          activeTicket = ticket;
          logger.f("Active ticket: ${activeTicket?.toJson()}");
          if (activeTicket != null) {
            updateMapView();
          } else {
            logger.w("Ticket closed");
          }
          update();
        } else {
          resetActiveTicket();
          logger.w("No data received: ${activeTicket?.toJson()} --");
          update();
        }
      });
    } catch (e, s) {
      logger.e(e, stackTrace: s);
    }
  }

  void resetActiveTicket() {
    activeTicket = null;
    logger.e("No data received: ${activeTicket?.toJson()} --");
    update();
  }

  updateMapView() {
    if (activeTicket?.buyer?.latitude != null &&
        activeTicket?.buyer?.longitude != null &&
        activeTicket?.deliverer?.latitude != null &&
        activeTicket?.deliverer?.longitude != null) {
      LatLng current = LatLng(
          activeTicket!.buyer!.latitude!, activeTicket!.buyer!.longitude!);
      LatLng destination = LatLng(activeTicket!.deliverer!.latitude!,
          activeTicket!.deliverer!.longitude!);

      Get.put(ViewersMapService()).getRoute(current, destination);
    }
    update();
  }

  createNewTicket({
    required String message,
    required Buyer buyerData,
    required List<MedicineModel?> cartMedicineList,
    required double amountPaid,
  }) async {
    final currentUserLocation = await LocationService().getCurrentLocation();
    OrderTicketModel ticket = OrderTicketModel(
      ticketId: generateRandomString(),
      message: message,
      timeCreated: DateTime.now(),
      isActive: true,
      medications: cartMedicineList,
      buyer: buyerData.copyWith(
        latitude: currentUserLocation?.latitude,
        longitude: currentUserLocation?.longitude,
      ),
      payment: Payment(amount: amountPaid, paid: true),
    );
    logger.f("New ticket: ${ticket.toJson()}");
    FirebaseRepo().createTicket(ticket);
  }

  fetchAllClosedTickets() async {
    loading = true;
    closedTicketsList = await FirebaseRepo().fecthClosedTickets();
    stopLoading();
    update();
  }

// Function to generate a random 12-character alphanumeric string
  String generateRandomId(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length))),
    );
  }

// Function to generate a random integer between 100 and 500
  int generateRandomItemsRemaining() {
    final random = Random();
    return 100 + random.nextInt(401); // Random number between 100 and 500
  }

  Future<void> uploadMedicineList() async {
    logger.w("Uploading medicines");
    // Reference to Firebase Realtime Database "inventory" collection
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child("inventory");

    // Loop through each item in the list and upload it to Firebase
    for (var medicine in medicineListJson) {
      // Create a modifiable copy of the map
      var modifiableMedicine = Map<String, dynamic>.from(medicine);

      // Add the random "id" and "itemsRemaining" keys to each medicine
      modifiableMedicine["id"] = generateRandomId(12);
      modifiableMedicine["itemsRemaining"] = generateRandomItemsRemaining();

      // Push the item to Firebase (Firebase will auto-generate a unique key for each item)
      await databaseRef.push().set(modifiableMedicine);
    }
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

String generateRandomString() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  return List.generate(12, (index) => chars[random.nextInt(chars.length)])
      .join();
}

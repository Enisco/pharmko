// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmko/controllers/main_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/services/location_service.dart';
import 'package:pharmko/services/viewers_map_service.dart';
import 'package:pharmko/shared/logger.dart';

class RiderController extends MainController {
  OrderTicketModel? activeTicket;

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

  Future<void> startLocationUpdates() async {
    await Geolocator.requestPermission();

    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);

    StreamSubscription<Position> streamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      logger.w('Lat: ${position.latitude}, Long: ${position.longitude}');
      if (activeTicket != null) {
        final updatedDeliverer = activeTicket!.deliverer!.copyWith(
            latitude: position.latitude, longitude: position.longitude);
        FirebaseRepo()
            .updateTicket(activeTicket!.copyWith(deliverer: updatedDeliverer));
      }
    });
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

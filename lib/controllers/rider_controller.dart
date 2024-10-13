// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/services/viewers_map_service.dart';
import 'package:pharmko/shared/logger.dart';

class RiderController extends GetxController {
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

  Future<void> startLocationUpdates() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied ||
        await Geolocator.checkPermission() ==
            LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

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

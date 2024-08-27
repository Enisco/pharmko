import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmko/shared/logger.dart';

class LocationService {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: "Enable Locations Permissions, then retry",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      await Geolocator.openAppSettings().then((_) async {
        await Geolocator.openLocationSettings();
      });
      // Location services are not enabled, prompt the user to enable them.
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permissions.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, request them again.
        return _determinePosition(); // Recursively call until permission is granted.
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: "Enable Locations Permissions, then retry",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      await Geolocator.openAppSettings().then((_) async {
        await Geolocator.openLocationSettings();
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true,
    );
  }

  Future<Position?> getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      logger.f('Current position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      logger.e('Error: $e');
      return null;
    }
  }
}

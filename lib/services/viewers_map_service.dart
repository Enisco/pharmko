// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmko/controllers/main_controller.dart';
import 'package:pharmko/shared/logger.dart';

class ViewersMapService extends MainController {
  LatLng? startLocation, destinationLocation;
  final Set<Polyline> polylines = <Polyline>{};

  Future<void> getRoute(LatLng start, LatLng destination) async {
    startLocation = start;
    destinationLocation = destination;
    try {
      final inParts = ["AIzaSyDvcHECvODl7a", "j5ctBkc3U9kfPD6AVDrI"];

      final response = await Dio().get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '${start.latitude},${start.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': '${inParts[0]}-${inParts[1]}',
          'mode': 'driving',
        },
      );

      if (response.statusCode == 200) {
        logger.w("Routes Data: ${response.data}");
        final routes = response.data['routes'];
        logger.f("Routes Data: $routes");

        if (routes.isNotEmpty) {
          final data = routes[0]['overview_polyline']['points'];
          final points = decodePolyline(data);

          polylines.clear();
          polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            width: 5,
            color: Colors.blue,
          ));
        } else {
          logger.w('No routes found');
        }
        update();
      }
    } catch (e) {
      logger.w('Error getting route: $e');
    }
    update();
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng(lat / 1E5, lng / 1E5);
      polyline.add(point);
    }

    update();
    return polyline;
  }
}

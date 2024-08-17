import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class ViewersMapScreen extends StatefulWidget {
  const ViewersMapScreen({super.key});

  @override
  State<ViewersMapScreen> createState() => _ViewersMapScreenState();
}

class _ViewersMapScreenState extends State<ViewersMapScreen> {
  List<LatLng> routePoints = [];
  late LatLng currentLocation;
  late LatLng endLocation;

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _getRoute() async {
    const startLat = 40.748817;
    const startLng = -73.985428;
    const endLat = 40.730610;
    const endLng = -73.935242;

    // TODO: get API
    const apiKey = 'YOUR_OPENROUTESERVICE_API_KEY';
    const url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey';

    final body = jsonEncode({
      'coordinates': [
        [startLng, startLat],
        [endLng, endLat],
      ],
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'] as List;

      setState(() {
        routePoints = coordinates
            .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      throw Exception('Failed to load route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Map Routing'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(40.748817, -73.985428),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            // subdomains: const ['server', 'services', 'www'],

          ),
          if (routePoints.isNotEmpty)
            MarkerLayer(
              markers: [
                Marker(
                  point: currentLocation,
                  child: const Icon(Icons.location_on),
                ),
                Marker(
                  point: endLocation,
                  child: const Icon(Icons.flag),
                ),
              ],
            ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

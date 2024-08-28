// import 'package:dio/dio.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:pharmko/controllers/main_controller.dart';
// import 'package:pharmko/shared/logger.dart';

// class ViewersMapService extends MainController {
//   LatLng? startLocation, destinationLocation;
//   final MapController mapController = MapController();
//   final List<Marker> markers = [];
//   final List<Polyline> polylines = [];
//   List<LatLng> routePoints = [];

//   final arcGisApiKey =
//       "AAPKb7a1d63200d747528ece8e0746d9a46dVWnWo2g8x_d1tQYqKI7QftZhrtPIwaAM2-stsoAAfcmimmd9BHcyMHDTGAJwz1d4";

//   void getRoute(LatLng start, LatLng destination) async {
//     try {
//       // final response = await Dio().get(
//       //   'https://api.openrouteservice.org/v2/directions/driving-car',
//       //   queryParameters: {
//       //     'api_key': arcGisApiKey, // Replace with your OpenRouteService API key
//       //     'start': '${start.longitude},${start.latitude}',
//       //     'end': '${destination.longitude},${destination.latitude}',
//       //   },
//       // );

//       final response = await Dio().get(
//         'https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World/solve',
//         queryParameters: {
//           'f': 'json',
//           'token': arcGisApiKey,
//           'stops':
//               '${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}',
//           'returnDirections': 'false',
//           'returnStops': 'false',
//           'returnBarriers': 'false',
//           'returnPolyline': 'true',
//           'outSR': '4326',
//         },
//       );

//       if (response.statusCode == 200) {
//         logger.f("Map response: $response");
//         final data =
//             response.data['features'][0]['geometry']['coordinates'] as List;
//         logger.w("Routes data: $data");
//         routePoints = data.map((coord) => LatLng(coord[1], coord[0])).toList();
//         logger.f("Routes Points: ${routePoints.length}");
//         update();
//       }
//     } catch (e) {
//       logger.e('Error getting route: $e');
//     }
//   }
// }

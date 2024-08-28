// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:pharmko/services/viewers_fmap_service.dart';

// class ViewersFMap extends StatefulWidget {
//   final LatLng? startLocation, destinationLocation;
//   const ViewersFMap({
//     super.key,
//     required this.startLocation,
//     required this.destinationLocation,
//   });

//   @override
//   State<ViewersFMap> createState() => _ViewersFMapState();
// }

// class _ViewersFMapState extends State<ViewersFMap> {
//   final controller = Get.put(ViewersMapService());

//   @override
//   void initState() {
//     super.initState();
//     controller.getRoute(
//       controller.startLocation ?? widget.startLocation!,
//       controller.destinationLocation ?? widget.destinationLocation!,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Viewers ')),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: controller.startLocation ?? widget.startLocation!,
//           initialZoom: 13.0,
//           onPositionChanged: (mapPosition, hasGesture) {
//             if (hasGesture) {
//               // Optionally, update the route when the map is moved manually
//               controller.getRoute(
//                 mapPosition.center,
//                 controller.destinationLocation ?? widget.destinationLocation!,
//               );
//             }
//           },
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: const ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: controller.startLocation ?? widget.startLocation!,
//                 child:
//                     const Icon(Icons.location_on, color: Colors.red, size: 40),
//               ),
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: controller.destinationLocation ??
//                     widget.destinationLocation!,
//                 child: const Icon(Icons.location_on,
//                     color: Colors.green, size: 40),
//               ),
//             ],
//           ),
//           PolylineLayer(
//             polylines: [
//               Polyline(
//                 points: controller.routePoints,
//                 strokeWidth: 4.0,
//                 color: Colors.blue,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

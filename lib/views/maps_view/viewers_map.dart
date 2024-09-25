import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/services/viewers_map_service.dart';

class ViewersMapView extends StatefulWidget {
  final LatLng start, destination;
  const ViewersMapView({
    super.key,
    required this.start,
    required this.destination,
  });

  @override
  State<ViewersMapView> createState() => _ViewersMapViewState();
}

class _ViewersMapViewState extends State<ViewersMapView> {
  final controller = Get.put(ViewersMapService());

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewersMapService>(
      initState: (state) {
        controller.getRoute(widget.start, widget.destination);
      },
      init: ViewersMapService(),
      builder: (ctxt) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            leadingWidth: 40,
            title: Text(
              'Delivery Route',
              style: AppStyles.regularStyle(fontSize: 18, color: Colors.white),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          body: GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: controller.startLocation!,
              zoom: 10.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('start'),
                position: controller.startLocation!,
              ),
              Marker(
                markerId: const MarkerId('destination'),
                position: controller.destinationLocation!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            },
            polylines: controller.polylines,
          ),
        );
      },
    );
  }
}

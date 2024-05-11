import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTracking extends StatefulWidget {
  const MapTracking({super.key});

  @override
  State<MapTracking> createState() => _MapTrackingState();
}

class _MapTrackingState extends State<MapTracking> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final googleAPIKey = "AIzaSyDqsYDCZEz3tbUEQGiUqUM-iZpL1evjGng"; // Add your Google Maps API Key here

  static const LatLng latLngSource =
      LatLng(30.307002906543936, 31.756348775876358);
  static const LatLng latLngDestination =
      LatLng(30.304093388476712, 31.744694033301066);

  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    getPolylinePoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: latLngSource, zoom: 13),
        markers: {
          const Marker(markerId: MarkerId("Source"), position: latLngSource),
          const Marker(
              markerId: MarkerId("Destination"), position: latLngDestination),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("polyline"),
            color: Colors.red,
            width: 5,
            points: polylineCoordinates,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }


  void getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey, // Google Maps API Key
      PointLatLng(latLngSource.latitude, latLngSource.longitude),
      PointLatLng(latLngDestination.latitude, latLngDestination.longitude),
    );
    if (result.points.isNotEmpty) {
      print("Polyline Points: ${result.points.length}");
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // Update the polyline
    });
  }




}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapTracking extends StatefulWidget {
  const MapTracking({super.key});

  @override
  State<MapTracking> createState() => _MapTrackingState();
}

class _MapTrackingState extends State<MapTracking> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final googleAPIKey =
      "AIzaSyCF-TZmwR-OP6ZZHv4EUIJrNQAgslB_Pl0"; // Add your Google Maps API Key here

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  static const LatLng latLngSource =
      LatLng(30.307002906543936, 31.756348775876358);
  static const LatLng latLngDestination =
      LatLng(30.304093388476712, 31.744694033301066);

  List<LatLng> polylineCoordinates = [];

  // get current location from user device
  LocationData? currentLocation;

  @override
  void initState() {
    getPolylinePoints();
    getCurrentLocation();
    changeBitmapIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition:
                  const CameraPosition(target: latLngSource, zoom: 13),
              markers: {
                Marker(
                    markerId: MarkerId("myLocation"),
                    icon: currentIcon,
                    position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!)),
                const Marker(
                    markerId: MarkerId("Source"), position: latLngSource),
                const Marker(
                    markerId: MarkerId("Destination"),
                    position: latLngDestination),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("polyline"),
                  color: Colors.blue,
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

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((value) {
      currentLocation = value;
    });

    GoogleMapController controller = await _controller.future;
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(cLoc.latitude!, cLoc.longitude!),
          tilt: 3,
          zoom: 30,
        ),
      ));
      setState(() {});
    });

    setState(() {});
  }

  void changeBitmapIcon()  {
     BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icons/car.png')
        .then((value) {
      currentIcon = value;
    });
  }
}

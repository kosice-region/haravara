import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPlaces {
  final Set<Marker> markers;
  final String locationName;
  final LatLngBounds bounds;
  final CameraPosition cameraPosition;
  LocationPlaces(
      {required this.markers,
      required this.cameraPosition,
      required this.locationName,
      required this.bounds});
}

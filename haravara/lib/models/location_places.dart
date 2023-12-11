import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPlaces {
  final Set<LocationPlaceMarker> markers;
  final String locationName;
  final LatLngBounds bounds;
  final CameraPosition cameraPosition;
  LocationPlaces(
      {required this.markers,
      required this.cameraPosition,
      required this.locationName,
      required this.bounds});
}

class LocationPlaceMarker extends Marker {
  final String markerID;
  final LatLng position;
  final InfoWindow infoWindow;
  final void Function(Marker) onTapAction;

  LocationPlaceMarker({
    required this.markerID,
    required this.position,
    required this.infoWindow,
    required this.onTapAction,
  }) : super(
          markerId: MarkerId(markerID),
          position: position,
          infoWindow: infoWindow,
          onTap: () {
            onTapAction(Marker(
                markerId: MarkerId(markerID),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: infoWindow));
          },
        );
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMarker extends Marker {
  final String markerID;
  final LatLng position;
  final InfoWindow infoWindow;
  final void Function(Marker) onTapAction;

  static const String _defaultIconPath = 'assets/Icon.jpeg';

  PlaceMarker._({
    required this.markerID,
    required this.position,
    required this.infoWindow,
    required this.onTapAction,
    required BitmapDescriptor icon,
  }) : super(
          markerId: MarkerId(markerID),
          position: position,
          infoWindow: infoWindow,
          onTap: () => onTapAction(Marker(
            markerId: MarkerId(markerID),
            position: position,
            infoWindow: infoWindow,
          )),
          icon: icon,
        );

  static Future<PlaceMarker> createWithDefaultIcon({
    required String markerID,
    required LatLng position,
    required InfoWindow infoWindow,
    required void Function(Marker) onTapAction,
  }) async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(4, 4)),
      _defaultIconPath,
    );

    return PlaceMarker._(
      markerID: markerID,
      position: position,
      infoWindow: infoWindow,
      onTapAction: onTapAction,
      icon: icon,
    );
  }
}

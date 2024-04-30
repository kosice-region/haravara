import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class PlaceMarker extends Marker {
  final String markerID;
  @override
  final LatLng position;
  @override
  final InfoWindow infoWindow;
  final void Function(Marker) onTapAction;

  static const String _defaultIconPath = 'assets/Icon.jpeg';

  PlaceMarker._({
    required this.markerID,
    required this.position,
    required this.infoWindow,
    required this.onTapAction,
    required super.icon,
  }) : super(
          markerId: MarkerId(markerID),
          position: position,
          infoWindow: infoWindow,
          onTap: () => onTapAction(Marker(
            markerId: MarkerId(markerID),
            position: position,
            infoWindow: infoWindow,
          )),
        );

  static Future<PlaceMarker> createWithDefaultIcon({
    required String markerID,
    required LatLng position,
    required InfoWindow infoWindow,
    required void Function(Marker) onTapAction,
    required int width,
  }) async {
    Future getBytesFromAsset() async {
      ByteData data = await rootBundle.load(_defaultIconPath);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
    }

    final Uint8List markerIcon = await getBytesFromAsset();

    return PlaceMarker._(
        markerID: markerID,
        position: position,
        infoWindow: infoWindow,
        onTapAction: onTapAction,
        icon: BitmapDescriptor.fromBytes(markerIcon));
  }
}

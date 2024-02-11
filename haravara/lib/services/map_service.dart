import 'package:flutter_riverpod/src/consumer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/models/place_marker.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/event_bus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show asin, cos, max, min, pi, sin, sqrt;

final eventBus = EventBus();

class MapService {
  final String key = 'AIzaSyCgHVN9XIIgGyCxlDYvOloDIkEcArxMkRw';

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future<Set<Marker>> getMarkers(List<Place> places) async {
    List<Future<Marker>> markerFutures = [];

    for (Place place in places) {
      LatLng primaryPos = LatLng(
        place.geoData.primary.coordinates[0],
        place.geoData.primary.coordinates[1],
      );

      markerFutures.add(
        PlaceMarker.createWithDefaultIcon(
          markerID: place.id.toString(),
          position: primaryPos,
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.detail.description,
          ),
          onTapAction: (marker) {
            eventBus.sendEvent(marker);
          },
        ),
      );
    }
    var markers = await Future.wait(markerFutures);
    return markers.toSet();
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    var p = 0.017453292519943295; // Константа для преобразования в радианы
    var c = cos;
    var a = 0.5 -
        c((point2.latitude - point1.latitude) * p) / 2 +
        c(point1.latitude * p) *
            c(point2.latitude * p) *
            (1 - c((point2.longitude - point1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * радиус Земли (6371 km)
  }

  LatLngBounds findBounds(List<LatLng> points) {
    double maxDistance = 0.0;
    LatLng point1 = const LatLng(0, 0), point2 = const LatLng(0, 0);

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        double distance = calculateDistance(points[i], points[j]);
        if (distance > maxDistance) {
          maxDistance = distance;
          point1 = points[i];
          point2 = points[j];
        }
      }
    }

    return LatLngBounds(
      southwest: LatLng(min(point1.latitude, point2.latitude),
          min(point1.longitude, point2.longitude)),
      northeast: LatLng(max(point1.latitude, point2.latitude),
          max(point1.longitude, point2.longitude)),
    );
  }

  CameraPosition calculateInitialCameraPosition(List<LatLng> points) {
    var bounds = findBounds(points);
    var centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    var centerLng =
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2;

    return CameraPosition(
      target: LatLng(centerLat, centerLng),
      zoom: 7.80,
    );
  }

  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    );
    return LatLng(position.latitude, position.longitude);
  }

  Future<Map<String, dynamic>> getDirections(
      LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$key';

    final String distanceUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var dResponse = await http.get(Uri.parse(distanceUrl));
    var dJson = convert.jsonDecode(dResponse.body);
    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
      'distance': dJson['rows'][0]['elements'][0]['distance']['text'] as String,
    };
    return results;
  }
}

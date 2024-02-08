import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haravara/firebase_options.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/services/notification_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class Init {
  static initialize(WidgetRef ref) async {
    print("starting registering services");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _requestLocationPermission();
    await _initPlacesAndMarkers(ref);
    print("finished registering services");
  }

  static _initPlacesAndMarkers(WidgetRef ref) async {
    await DatabaseService().getAllPlaces(ref);
    await MapService().getMarkers(ref);
  }

  static _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

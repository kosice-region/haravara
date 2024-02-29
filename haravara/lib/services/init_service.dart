import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/models/setup_model.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/services/places_service.dart';

final PlacesService placesService = PlacesService();
final MapService mapService = MapService();

class Init {
  static initialize(WidgetRef ref) async {
    print("starting registering services");
    SetupModel model = ref.watch(setupNotifierProvider);
    print(model);
    if (model.isFirstSetup) {
      print('first setup');
      await _firstSetup(ref, model);
    } else if (!model.isFirstSetup) {
      print('isnt first');
      await _defaultSetup(ref);
    }
    final test = ref.watch(loginNotifierProvider);
    print(test);
    print("finished registering services");
  }

  static _firstSetup(WidgetRef ref, SetupModel model) async {
    print('1');
    // await _requestLocationPermission();
    print('2');
    await placesService.savePlacesLocally();
    model.isFirstSetup = false;
    ref.read(setupNotifierProvider.notifier).updateSetup(
        model.isFirstSetup, model.isLoggedIn, model.versionOfDatabase);

    _defaultSetup(ref);
  }

  static _defaultSetup(WidgetRef ref) async {
    final List<Place> places = await placesService.loadPlaces();
    final Set<Marker> markers = await mapService.getMarkers(places);
    ref.read(placesProvider.notifier).addPlaces(places);
    ref.read(markersProvider.notifier).setMarkers(markers);
  }

  static _requestLocationPermission() async {
    LocationPermission permission;

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

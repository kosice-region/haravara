import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/models/setup_model.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/repositories/location_repository.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/services/places_service.dart';
import 'package:permission_handler/permission_handler.dart';

final PlacesService placesService = PlacesService();
final MapService mapService = MapService();

class Init {
  static initialize(WidgetRef ref) async {
    print("starting registering services");
    SetupModel model = ref.watch(setupNotifierProvider);
    if (model.isFirstSetup) {
      print('first setup');
      await _firstSetup(ref, model);
    } else if (!model.isFirstSetup) {
      print('isnt first');
      await _defaultSetup(ref);
    }
    print("finished registering services");
  }

  static _firstSetup(WidgetRef ref, SetupModel model) async {
    print('1');
    await _requestLocationPermission();
    print('2');
    await placesService.savePlacesLocally();
    model.isFirstSetup = false;
    ref.read(setupNotifierProvider.notifier).updateSetup(
        model.isFirstSetup, model.isLoggedIn, model.versionOfDatabase);

    _defaultSetup(ref);
  }

  static _defaultSetup(WidgetRef ref) async {
    await _requestLocationPermission();
    final List<Place> places = await placesService.loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
  }

  static _requestLocationPermission() async {
    await Permission.location.request();
    var status = await Permission.locationAlways.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.locationAlways.request();
    }
    status = await Permission.locationAlways.status;
    if (status.isGranted) {
      print("Location Always permission granted.");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      print("Location Always permission denied.");
    }
  }
}

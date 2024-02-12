import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/main.dart';
import 'package:haravara/models/place.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addPlaces(List<Place> places) {
    state = [...state, ...places];
  }

  Place getPlaceById(String id) {
    return state.firstWhere(
      (place) => place.id == id,
    );
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});

class MarkersNotifier extends StateNotifier<Set<Marker>> {
  MarkersNotifier() : super({});

  void setMarkers(Set<Marker> markers) {
    state = markers;
  }
}

final markersProvider =
    StateNotifierProvider<MarkersNotifier, Set<Marker>>((ref) {
  return MarkersNotifier();
});

class PickedPlaceNotifier extends StateNotifier<String> {
  PickedPlaceNotifier(this.pref) : super(_initialSetup(pref));

  static String _initialSetup(SharedPreferences pref) {
    return pref.getString('curPlaceId') ?? 'null';
  }

  final SharedPreferences pref;

  void setNewPlace(String placeId) {
    state = placeId;
    pref.setString('curPlaceId', placeId);
  }
}

final pickedPlaceProvider =
    StateNotifierProvider<PickedPlaceNotifier, String>((ref) {
  final SharedPreferences pref = ref.read(sharedPreferencesProvider);
  return PickedPlaceNotifier(pref);
});

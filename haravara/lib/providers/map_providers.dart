import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/place.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addPlaces(List<Place> places) {
    state = [...state, ...places];
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/place.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addPlaces(List<Place> places) {
    state = [...state, ...places];
  }
}

final PlacesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});

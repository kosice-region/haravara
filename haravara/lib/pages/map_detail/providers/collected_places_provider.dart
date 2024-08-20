import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectedPlacesNotifier extends StateNotifier<List<String>> {
  CollectedPlacesNotifier(this.pref) : super(_initialSetup(pref));

  final SharedPreferences pref;

  static List<String> _initialSetup(SharedPreferences pref) {
    pref.reload();
    return pref.getStringList('collectedPlaces') ?? [];
  }

  void setPlaces(List<String> placesIds) {
    state = [...state, ...placesIds];
    pref.setStringList('collectedPlaces', state);
  }

  void addNewPlace(String placeId) {
    if (!state.contains(placeId)) {
      state = [...state, placeId];
      pref.setStringList('collectedPlaces', state);
    }
  }

  void deletePlace(String placeId) {
    state = state.where((id) => id != placeId).toList();
    pref.setStringList('collectedPlaces', state);
  }

  void deleteAllPlaces() {
    state = [];
    pref.remove('collectedPlaces');
  }
}

final collectedPlacesProvider =
    StateNotifierProvider<CollectedPlacesNotifier, List<String>>((ref) {
  final SharedPreferences pref = ref.read(sharedPreferencesProvider);
  return CollectedPlacesNotifier(pref);
});

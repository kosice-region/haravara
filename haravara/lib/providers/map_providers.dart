import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/main.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addPlaces(List<Place> places) {
    state = [...places];
  }

  Place getPlaceById(String id) {
    return state.firstWhere(
      (place) => place.id == id,
    );
  }

  List<Place> getSortedPlaces(bool sortForward) {
    List<Place> reachedPlaces = [];
    List<Place> unreachedPlaces = [];
    for (var place in state) {
      if (place.isReached) {
        reachedPlaces.add(place);
      } else {
        unreachedPlaces.add(place);
      }
    }
    if (sortForward) {
      return [...reachedPlaces, ...unreachedPlaces];
    } else {
      return [...unreachedPlaces, ...reachedPlaces];
    }
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});

final placesFutureProvider = FutureProvider<List<Place>>((ref) async {
  return await DatabaseService().loadPlaces();
});

class RichedPlacesNotifier extends StateNotifier<List<String>> {
  RichedPlacesNotifier(this.pref) : super(_initialSetup(pref));

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

final richedPlacesProvider =
    StateNotifierProvider<RichedPlacesNotifier, List<String>>((ref) {
  final SharedPreferences pref = ref.read(sharedPreferencesProvider);
  return RichedPlacesNotifier(pref);
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

class AssetImageNotifier extends StateNotifier<File> {
  AssetImageNotifier() : super(File('assets/places-map.jpg'));
}

final assetImageProvider =
    StateNotifierProvider<AssetImageNotifier, File>((ref) {
  return AssetImageNotifier();
});

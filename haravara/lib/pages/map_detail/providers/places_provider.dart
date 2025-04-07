
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/core/models/place.dart';

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

  List<Place> getCollectedPlaces() {
    return state.where((place) => place.isReached).toList();
  }

  List<Place> getSortedPlacesForward(bool sortForward) {
    List<Place> collectedPlaces = getCollectedPlaces();
    List<Place> uncollectedPlaces =
        state.where((place) => !place.isReached).toList();

    log(sortForward.toString());
    if (sortForward) {
      return [...collectedPlaces, ...uncollectedPlaces];
    } else {
      return [...uncollectedPlaces, ...collectedPlaces];
    }
  }

  String getLevelOfSearcher() {
    int collectedPlacesLength = getCollectedPlaces().length;
    // int collectedPlacesLength = 20; //Uncomment it if you test each variant
    const List<Map<String, dynamic>> levels = [
      {'threshold': 60, 'level': 'dúhový jednorožec'},
      {'threshold': 55, 'level': 'pyšný páv'},
      {'threshold': 50, 'level': 'tajomný panter'},
      {'threshold': 45, 'level': 'šikovná veverička'},
      {'threshold': 40, 'level': 'splašená čivava'},
      {'threshold': 35, 'level': 'zvedavá surikata'},
      {'threshold': 30, 'level': 'vyhúkaná sova'},
      {'threshold': 25, 'level': 'vytrvalý bobor'},
      {'threshold': 20, 'level': 'popletená chobotnička'},
      {'threshold': 15, 'level': 'turbo leňochod'},
      {'threshold': 10, 'level': 'vytrvalý slimáčik'},
      {'threshold': 5, 'level': 'ospalý pavúčik'},
    ];

    for (var level in levels) {
      if (collectedPlacesLength >= (level['threshold'] as num)) {
        return 'Som ${level['level']}';
      }
    }

    return 'Som pátrač začiatočník';
  }

  double getProgressToNextMilestone() {
    int collectedPlacesLength = getCollectedPlaces().length;
    const List<int> thresholds = [10, 20, 30, 40];

    for (int i = 0; i < thresholds.length; i++) {
      if (collectedPlacesLength < thresholds[i]) {
        int previousThreshold = i == 0 ? 0 : thresholds[i - 1];
        return (collectedPlacesLength - previousThreshold) /
            (thresholds[i] - previousThreshold);
      }
    }
    return 1.0;
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});

final placesFutureProvider = FutureProvider<List<Place>>((ref) async {
  return await DatabaseService().loadPlaces();
});

final collectedPlacesProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  return DatabaseService().loadCollectedPlaceIdsStream(userId);
});


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

    if (sortForward) {
      return [...collectedPlaces, ...uncollectedPlaces];
    } else {
      return [...uncollectedPlaces, ...collectedPlaces];
    }
  }

  String getLevelOfSearcher() {
    int collectedPlacesLength = getCollectedPlaces().length;
    const List<Map<String, dynamic>> levels = [
      {'threshold': 40, 'level': 'expert'},
      {'threshold': 30, 'level': 'pokročilý'},
      {'threshold': 20, 'level': 'stredne pokročilý'},
      {'threshold': 10, 'level': 'mierne pokročilý'},
    ];

    for (var level in levels) {
      if (collectedPlacesLength >= (level['threshold'] as num)) {
        return 'Si pátrač ${level['level']}';
      }
    }

    return 'Si pátrač začiatočník';
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

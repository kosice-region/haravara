import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickedPlaceNotifier extends StateNotifier<PickedPlaceState> {
  PickedPlaceNotifier(this.pref) : super(PickedPlaceState());

  final SharedPreferences pref;

  void setNewPlace(String placeId, {bool centerOnPlace = false}) {
    state = PickedPlaceState(
        placeId: placeId, showPreview: true, centerOnPlace: centerOnPlace);
    pref.setString('curPlaceId', placeId);
  }

  void resetPreview() {
    state = state.copyWith(showPreview: false);
  }

  void resetCenter() {
    state = state.copyWith(centerOnPlace: false);
  }

  void resetPlace() {
    state = PickedPlaceState();
    pref.remove('curPlaceId');
  }
}

final pickedPlaceProvider =
    StateNotifierProvider<PickedPlaceNotifier, PickedPlaceState>((ref) {
  final SharedPreferences pref = ref.read(sharedPreferencesProvider);
  return PickedPlaceNotifier(pref);
});

class PickedPlaceState {
  final String placeId;
  final bool showPreview;
  final bool centerOnPlace;

  PickedPlaceState(
      {this.placeId = 'null',
      this.showPreview = false,
      this.centerOnPlace = false});

  PickedPlaceState copyWith(
      {String? placeId, bool? showPreview, bool? centerOnPlace}) {
    return PickedPlaceState(
      placeId: placeId ?? this.placeId,
      showPreview: showPreview ?? this.showPreview,
      centerOnPlace: centerOnPlace ?? this.centerOnPlace,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/models/setup_model.dart';
import 'package:haravara/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupNotifier extends StateNotifier<SetupModel> {
  SetupNotifier(this.pref) : super(_initialSetup(pref));

  final SharedPreferences pref;

  static SetupModel _initialSetup(SharedPreferences? pref) {
    bool isFirstSetup = pref?.getBool("isFirstSetup") ?? true;
    bool isLoggedIn = pref?.getBool("isLoggedIn") ?? false;
    String versionOfDatabase = pref?.getString("versionOfDatabase") ?? '1.0.0';

    return SetupModel(
        isFirstSetup: isFirstSetup,
        isLoggedIn: isLoggedIn,
        versionOfDatabase: versionOfDatabase);
  }

  void updateSetup(
      bool isFirstSetup, bool isLoggedIn, String versionOfDatabase) {
    state = SetupModel(
        isFirstSetup: isFirstSetup,
        isLoggedIn: isLoggedIn,
        versionOfDatabase: versionOfDatabase);

    pref.setBool("isFirstSetup", isFirstSetup);
    pref.setBool("isLoggedIn", isLoggedIn);
    pref.setString("versionOfDatabase", versionOfDatabase);
  }
}

final setupNotifierProvider =
    StateNotifierProvider<SetupNotifier, SetupModel>((ref) {
  final SharedPreferences pref = ref.read(sharedPreferencesProvider);
  return SetupNotifier(pref);
});

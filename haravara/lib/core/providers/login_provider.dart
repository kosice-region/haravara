import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/main.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends StateNotifier<UserModel> {
  LoginNotifier(this.pref) : super(_initialUser(pref));

  final SharedPreferences pref;

  static UserModel _initialUser(SharedPreferences pref) {
    bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;
    String username = pref.getString("username") ?? '';
    String email = pref.getString("email") ?? '';
    String location = pref.getString("location") ?? '';
    String id = pref.getString("id") ?? '';
    int children = pref.getInt("children") ?? -1;
    return UserModel(
        isLoggedIn: isLoggedIn,
        username: username,
        email: email,
        id: id,
        children: children,
        location: location);
  }

  void login(
      String username, String email, String id, int children, String location) {
    state = UserModel(
        isLoggedIn: true,
        username: username,
        email: email,
        id: id,
        children: children,
        location: location);
    pref.setBool("isLoggedIn", true);
    pref.setString("username", username);
    pref.setString("email", email);
    pref.setString("id", id);
    pref.setString("location", location);
    pref.setInt("children", children);
  }

  void logout() {
    state = UserModel(isLoggedIn: false, username: '', email: '', id: '');
    pref.setBool("isLoggedIn", false);
    pref.remove("username");
    pref.remove("email");
    pref.remove("location");
    pref.remove("children");
    pref.remove("id");
    pref.remove("profile_image");
    pref.setBool("isLoggedIn", false);
  }
}

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, UserModel>((ref) {
  final pref = ref.read(sharedPreferencesProvider);
  return LoginNotifier(pref);
});

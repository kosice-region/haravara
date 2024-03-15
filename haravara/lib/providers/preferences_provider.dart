import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/auth_state.dart';
import 'package:haravara/main.dart';
import 'package:haravara/models/setup_model.dart';
import 'package:haravara/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends StateNotifier<UserModel> {
  LoginNotifier(this.pref) : super(_initialUser(pref));

  final SharedPreferences pref;

  static UserModel _initialUser(SharedPreferences pref) {
    bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;
    String username = pref.getString("username") ?? '';
    String email = pref.getString("email") ?? '';
    String id = pref.getString("id") ?? '';
    return UserModel(
        isLoggedIn: isLoggedIn, username: username, email: email, id: id);
  }

  void login(String username, String email, String id) {
    state =
        UserModel(isLoggedIn: true, username: username, email: email, id: id);
    pref.setBool("isLoggedIn", true);
    pref.setString("username", username);
    pref.setString("email", email);
    pref.setString("id", id);
  }

  void logout() {
    state = UserModel(isLoggedIn: false, username: '', email: '', id: '');
    pref.setBool("isLoggedIn", false);
    pref.remove("username");
    pref.remove("email");
    pref.remove("id");
  }
}

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, UserModel>((ref) {
  final pref = ref.read(sharedPreferencesProvider);
  return LoginNotifier(pref);
});

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

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void updateCode(String code) {
    state = state.copyWith(code: code);
  }

  void setEnteredUsername(String? username) {
    state = state.copyWith(enteredUsername: username);
  }

  void setEnteredEmail(String? email) {
    state = state.copyWith(enteredEmail: email);
  }

  void setUserId(String? id) {
    state = state.copyWith();
  }

  void toggleLoginState(bool newState) {
    state = state.copyWith(isLogin: newState);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

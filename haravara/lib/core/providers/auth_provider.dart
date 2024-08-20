import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/pages/auth/models/auth_state.dart';
import 'package:haravara/pages/auth/models/user.dart';

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

  void setEnteredChildren(int children) {
    state = state.copyWith(children: children);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setUserId(String? id) {
    state = state.copyWith();
  }

  void toggleLoginState(bool newState) {
    state = state.copyWith(isLogin: newState);
  }

  void toggleFamilyState(bool newState) {
    state = state.copyWith(isFamily: newState);
  }

  void toggleRememberState(bool newState) {
    state = state.copyWith(isNeedToRemeber: newState);
  }

  String? getEnteredUsername() {
    return state.enteredUsername;
  }

  String? getEnteredEmail() {
    return state.enteredEmail;
  }

  String? getEnteredLocation() {
    return state.location;
  }

  String? getUserId() {
    return state.userId;
  }

  int? getUserChildren() {
    return state.children;
  }

  bool isLogin() {
    return state.isLogin;
  }

  bool isNeedToRemeber() {
    return state.isLogin;
  }

  bool isFamily() {
    return state.isFamily;
  }

  UserModel getUserData() {
    return UserModel(
        email: state.enteredEmail!,
        id: state.userId,
        isLoggedIn: true,
        isFamily: state.isFamily,
        location: state.location ?? '',
        children: state.children ?? -1,
        username: state.enteredUsername ?? '');
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

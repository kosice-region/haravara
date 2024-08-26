import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/main.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_info_provider.g.dart';

@Riverpod(keepAlive: true)
class UserInfo extends _$UserInfo {
  @override
  UserModel build() {
    ref.onDispose(() {
      log('userInfo disposed');
    });
    final SharedPreferences pref = ref.watch(sharedPreferencesProvider);
    bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;
    String username = pref.getString("username") ?? '';
    String email = pref.getString("email") ?? '';
    String location = pref.getString("location") ?? '';
    String id = pref.getString("id") ?? '';
    int children = pref.getInt("children") ?? -1;
    // bool isFamily = (pref.getString('profileType') ?? 'family') == 'family';
    bool isFamily = (pref.getString('profileType') ?? 'individual') == 'family';


    state = new UserModel(
        isLoggedIn: isLoggedIn,
        username: username,
        email: email,
        id: id,
        children: children,
        location: location,
        isFamily: isFamily);
    return state;
  }

  Future<void> updateUsername(String newUsername) async {
    final SharedPreferences pref = ref.watch(sharedPreferencesProvider);
    await pref.setString('username', newUsername);
    state = state.copyWith(username: newUsername);
  }

  Future<void> updateLocation(String newLocation) async {
    final SharedPreferences pref = ref.watch(sharedPreferencesProvider);
    await pref.setString('location', newLocation);
    state = state.copyWith(location: newLocation);
  }

  Future<void> updateProfileType(bool isFamily) async {
  final SharedPreferences pref = ref.watch(sharedPreferencesProvider);
  await pref.setString('profileType', isFamily ? 'family' : 'individual');
  state = state.copyWith(isFamily: isFamily);
  }

  Future<void> updateCountOfChildren(int children) async {
  final SharedPreferences pref = ref.watch(sharedPreferencesProvider);
  await pref.setInt('children', children);
  state = state.copyWith(children: children);
  }


  Future<void> clear() async {
    final SharedPreferences pref = ref.watch(sharedPreferencesProvider);
    await pref.remove('isLoggedIn');
    await pref.remove('username');
    await pref.remove('email');
    await pref.remove('location');
    await pref.remove('id');
    await pref.remove('children');
    await pref.remove('profileType');

    state = UserModel(
        isLoggedIn: false,
        username: '',
        email: '',
        id: '',
        children: -1,
        location: '',
        isFamily: false);
  }
}

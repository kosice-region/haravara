import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/main.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarsNotifier extends ChangeNotifier {
  List<UserAvatar> avatars = [];
  static const String defaultId = '0387c644-249c-4c1e-ac0b-bc6c861d580c';
  final Ref ref;

  Map<String, String> _cachedData = {};

  AvatarsNotifier(this.ref);

  void addAvatars(List<UserAvatar> newAvatars) {
    avatars = newAvatars;
    notifyListeners();
  }

  void addAvatar(UserAvatar avatar) {
    avatars.add(avatar);
    notifyListeners();
  }

  void deleteAvatar(UserAvatar avatar) {
    avatars = avatars.where((a) => a.id != avatar.id).toList();
    notifyListeners();
  }

  UserAvatar getCurrentAvatar() {
    final SharedPreferences pref = ref.read(sharedPreferencesProvider);
    String currentAvatarId = pref.getString("profile_image") ?? '';
    if (currentAvatarId.isEmpty) {
      currentAvatarId = defaultId;
    }

    final avatar = avatars.firstWhere(
      (avatarImage) => avatarImage.id == currentAvatarId,
      orElse: () =>
          avatars.firstWhere((avatarImage) => avatarImage.id == defaultId),
    );
    return avatar;
  }

  void updateAvatar(String id) {
    final SharedPreferences pref = ref.read(sharedPreferencesProvider);
    if (id.isEmpty) {
      return;
    }
    pref.setString("profile_image", id);
    notifyListeners();
  }

  Map<String, String> getAllUserIdsAndAvatarLocations() {
    Map<String, String> result = {};
    for (var avatar in avatars) {
      if (avatar.id != null && avatar.location != null) {
        result[avatar.id!] = avatar.location!;
      }
    }
    log("Users Avatars: ${result.toString()}");
    if (!mapEquals(_cachedData, result)) {
      _cachedData = result;
    }
    return _cachedData;
  }
}

final avatarsProvider = ChangeNotifierProvider<AvatarsNotifier>((ref) {
  return AvatarsNotifier(ref);
});

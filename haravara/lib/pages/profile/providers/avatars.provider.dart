import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/main.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarsNotifier extends ChangeNotifier {
  List<UserAvatar> avatars = [];
  static String defaultId = '0387c644-249c-4c1e-ac0b-bc6c861d580c';
  final Ref ref;

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
}

final avatarsProvider = ChangeNotifierProvider<AvatarsNotifier>((ref) {
  return AvatarsNotifier(ref);
});

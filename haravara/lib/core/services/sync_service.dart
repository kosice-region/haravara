import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/services/database_service.dart';

import 'dart:developer' as dev;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:haravara/pages/auth/models/user.dart' as local_user;
import '../../pages/auth/models/user.dart';
import '../../pages/auth/services/auth_service.dart';
import '../../pages/profile/providers/avatars.provider.dart';
import '../../pages/profile/providers/user_info_provider.dart';
import '../providers/auth_provider.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());

final syncServiceProvider = Provider<SyncService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return SyncService(databaseService);
});


class SyncService {
  final DatabaseService _databaseService;

  SyncService(this._databaseService);

  Future<bool> syncPendingCollections() async {
    dev.log('Checking for pending collections to sync...');
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      dev.log('No internet connection. Sync postponed.');
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final List<String> pending = prefs.getStringList('pending_collections') ?? [];

    if (pending.isEmpty) {
      dev.log('No pending collections to sync.');
      return false;
    }

    dev.log('Syncing ${pending.length} collections...');
    List<String> successfullySyncedIds = [];

    for (String placeId in pending) {
      try {
        await _databaseService.addPlaceToCollectedByUser(placeId);
        successfullySyncedIds.add(placeId);
        dev.log('Successfully synced place $placeId.');
      } catch (e) {
        dev.log('Failed to sync place $placeId: $e. Will retry later.');
      }
    }

    if (successfullySyncedIds.isNotEmpty) {
      final List<String> updatedPending = List.from(pending)
        ..removeWhere((id) => successfullySyncedIds.contains(id));

      await prefs.setStringList('pending_collections', updatedPending);
      dev.log('Pending queue updated.');
      return true; // Return true to indicate that a refresh is needed
    }

    return false;
  }

  Future<void> fetchUserDataAndUpdateProviders(
      String userId, WidgetRef ref) async {
    local_user.User? user = await getUserById(userId);
    if (user == null) {
      log('User not found after authentication.');
      return;
    }

    log('User retrieved: ${user.username} - ${user.email}');

    await getCollectedPlacesByUser(userId);

    bool isFamily = user.userProfile!.profileType == ProfileType.family;
    String location = user.userProfile!.location ?? '';
    int children = user.userProfile!.children ?? -1;

    await ref.read(userInfoProvider.notifier).updateUserId(userId);
    log('FETCHING - update userId: $userId');

    await ref.read(userInfoProvider.notifier).updateUsername(user.username);
    log('FETCHING - username: ${user.username}');

    await ref.read(userInfoProvider.notifier).updateProfileType(isFamily);
    log('FETCHING - profileType: ${isFamily ? 'family' : 'individual'}');

    await ref.read(userInfoProvider.notifier).updateCountOfChildren(children);
    log('FETCHING - children: $children');

    ref.read(authNotifierProvider.notifier).setEnteredUsername(user.username);
    log('FETCHING - enteredUsername: ${user.username}');

    ref.read(authNotifierProvider.notifier).setEnteredEmail(user.email);
    log('FETCHING - enteredEmail: ${user.email}');

    ref.read(authNotifierProvider.notifier).setUserId(user.id);
    log('FETCHING - userId: ${user.id}');

    ref.read(authNotifierProvider.notifier).setLocation(location);
    log('FETCHING - location: $location');

    ref.read(authNotifierProvider.notifier).setEnteredChildren(children);
    log('FETCHING - enteredChildren: $children');

    ref.read(authNotifierProvider.notifier).toggleFamilyState(isFamily);
    log('FETCHING - familyState: ${isFamily ? 'family' : 'individual'}');

    await DatabaseService().saveUserAvatarsLocally(userId);
    final List<UserAvatar> avatars = await DatabaseService().loadAvatars();
    ref.read(avatarsProvider.notifier).addAvatars(avatars);
    log('FETCHING - avatars loaded and updated.');

    log('User data fetched and providers updated.');
  }

  Future<void> getCollectedPlacesByUser(String id) async {
    await DatabaseService().getCollectedPlacesByUser(id);
  }

  Future<local_user.User?> getUserById(String userId) async {
    return authRepository.getUserById(userId);
  }
}
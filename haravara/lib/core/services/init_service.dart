import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/core/models/setup_model.dart';
import 'package:haravara/core/providers/initialization_provider.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/map_detail/services/map_service.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../pages/map_detail/map_detail.dart';

final DatabaseService databaseService = DatabaseService();
final MapService mapService = MapService();

class Init {
  static initialize(WidgetRef ref) async {
    log("starting registering services");
    SetupModel model = ref.watch(setupNotifierProvider);
    if (model.isFirstSetup) {
      log('first setup');
      await _firstSetup(ref, model);
    } else {
      log('isnt first');
      await _defaultSetup(ref);
    }
    log("finished registering services");
  }

  static _firstSetup(WidgetRef ref, SetupModel model) async {
    await _requestLocationPermission();
    await databaseService.saveAvatarsLocally();
    await databaseService.savePlacesLocally(onProgress: (progress) {
      ref
          .read(initializationProgressProvider.notifier)
          .updateProgress(progress);
    });
    model.isFirstSetup = false;
    ref.read(setupNotifierProvider.notifier).updateSetup(
        model.isFirstSetup, model.isLoggedIn, model.versionOfDatabase);
    ref.read(userInfoProvider);
    _defaultSetup(ref);
  }

  static _defaultSetup(WidgetRef ref) async {
    await _requestLocationPermission();
    final List<Place> places = await databaseService.loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
    final List<UserAvatar> avatars = await databaseService.loadAvatars();
    ref.read(avatarsProvider.notifier).addAvatars(avatars);
    ref.read(loginNotifierProvider.notifier);
  }

  static Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      var alwaysStatus = await Permission.locationAlways.status;
      if (!alwaysStatus.isGranted) {
        var newAlwaysStatus = await Permission.locationAlways.request();
        if (newAlwaysStatus.isGranted) {
          print("Location Always permission granted.");
        } else {
          print("User chose not to grant Location Always permission.");
        }
      } else {
        print("Already have Location Always permission.");
      }
    } else if (status.isDenied) {
      var newStatus = await Permission.location.request();
      if (newStatus.isGranted) {
        var alwaysStatus = await Permission.locationAlways.request();
        if (alwaysStatus.isGranted) {
          print("Location Always permission granted.");
        } else {
          print("User chose not to grant Location Always permission.");
        }
      } else {
        print("Location When In Use permission denied.");
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      print("Location permission is in a restricted/limited state.");
    }
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/firebase_options.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/services/notification_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class Init {
  static initialize(WidgetRef ref) async {
    print("starting registering services");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _initPlacesAndMarkers(ref);
    print("finished registering services");
  }

  static _initPlacesAndMarkers(WidgetRef ref) async {
    await DatabaseService().getAllPlaces(ref);
    await MapService().getMarkers(ref);
  }
}

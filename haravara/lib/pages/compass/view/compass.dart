import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/models/place.dart';
import '../../../core/services/database_service.dart';
import '../../../router/router.dart';
import '../functions/compass_functions.dart';
import 'package:haravara/core/services/sync_service.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/close_button.dart';
import '../../map_detail/map_detail.dart';
import '../widgets/widgets.dart';


final distanceAndBearingProvider = StateProvider<Map<String, double>>((ref) {
  return {'distance': 0.0, 'bearing': 0.0};
});


class Compass extends ConsumerStatefulWidget {
  const Compass({super.key});

  @override
  ConsumerState<Compass> createState() => _CompassState();
}

class _CompassState extends ConsumerState<Compass> {
  double? _heading;
  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<Position>? _positionSubscription;

  static const double kCollectionRadiusMeters = 30.0;

  @override
  void initState() {
    super.initState();
    _initializeCompass();
    _initializeLocationStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerSync();
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _initializeCompass() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() => _heading = event.heading);
      }
    });
  }

  void _initializeLocationStream() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((position) {
      final pickedPlaceId = ref.read(pickedPlaceProvider).placeId;

      if (pickedPlaceId != 'null') {
        final pickedPlace = ref.read(placesProvider.notifier).getPlaceById(pickedPlaceId);
        _updateDistanceAndBearing(position, pickedPlace);
      }
    }, onError: (e) {
      dev.log('Location Stream Error: $e');
    });
  }

  void _updateDistanceAndBearing(Position currentUserPosition, Place targetPlace) {
    if (targetPlace.isReached) {
      if (mounted) {
        ref.read(distanceAndBearingProvider.notifier).state = {
          'distance': 0.0,
          'bearing': 0.0,
        };
      }
      return;
    }

    final targetLat = targetPlace.geoData.primary.coordinates[0];
    final targetLng = targetPlace.geoData.primary.coordinates[1];

    final distance = Geolocator.distanceBetween(
      currentUserPosition.latitude,
      currentUserPosition.longitude,
      targetLat,
      targetLng,
    );

    final bearing = calculateBearing(
      currentUserPosition.latitude,
      currentUserPosition.longitude,
      targetLat,
      targetLng,
    );

    if (mounted) {
      ref.read(distanceAndBearingProvider.notifier).state = {
        'distance': distance,
        'bearing': bearing,
      };
    }

    _checkAndHandleCollection(distance, targetPlace);
  }

  Future<void> _checkAndHandleCollection(double distance, Place placeToCollect) async {
    if (distance <= kCollectionRadiusMeters && !placeToCollect.isReached) {
      _positionSubscription?.pause();

      showCongratulationsDialog(context, placeToCollect.name);


        dev.log('User collected stamp for ${placeToCollect.name}');
        await _addCollectionToPendingQueue(placeToCollect.id!);

        final syncService = ref.read(syncServiceProvider);
        final needsRefresh = await syncService.syncPendingCollections();

        if (mounted && needsRefresh) {
          await initPlaces();
        }



    }
  }

  Future<void> _addCollectionToPendingQueue(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> pending = prefs.getStringList('pending_collections') ?? [];

    if (!pending.contains(placeId)) {
      pending.add(placeId);
      await prefs.setStringList('pending_collections', pending);
      dev.log('Place $placeId saved to pending queue.');
    }
  }

  Future<void> initPlaces() async {
    final places = await DatabaseService().loadPlaces();
    if (mounted) {
      ref.read(placesProvider.notifier).addPlaces(places);
    }
  }

  Future<void> _triggerSync() async {
    dev.log("Compass: Kicking off sync.");
    final syncService = ref.read(syncServiceProvider);
    final needsRefresh = await syncService.syncPendingCollections();

    if (mounted && needsRefresh) {
      await initPlaces();
    }
  }

  void showCongratulationsDialog(BuildContext context, String pickedPlaceName) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CongratulationsDialog(pickedPlaceName: pickedPlaceName);
        },
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    final pickedPlaceId = ref.watch(pickedPlaceProvider).placeId;

    if (pickedPlaceId == 'null') {
      return const Scaffold(
        body: Center(child: Text("Please select a destination.")),
      );
    }

    final distanceAndBearing = ref.watch(distanceAndBearingProvider);
    final distanceToTarget = distanceAndBearing['distance'] ?? 0.0;


    final bearingToTarget = distanceAndBearing['bearing'] ?? 0.0;
    final direction = calculateCompassDirection(_heading ?? 0.0, bearingToTarget);

    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          const BackgroundImage(
            image: 'assets/backgrounds/background_clouds.png',
          ),
          Center(
            child: Container(
              width: 230.w,
              height: 230.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(120).r),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const BuildCompass(), // The static compass rose background
                  Transform.rotate(
                    angle: (direction * (math.pi / 180)),
                    child: Image.asset(
                      "assets/compass-fixed.png",
                      scale: 1.1,
                      width: 200.w,
                      height: 300.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(
              screenType: ScreenType.detailMap,
              shouldPop: true,
            ),
          ),
          Distance(
            distanceToTarget: distanceToTarget,
          ),
        ],
      ),
    );
  }
}
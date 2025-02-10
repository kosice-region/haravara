import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/core/services/notification_service.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/compass/distance_model.dart';
import 'package:haravara/pages/compass/functions/compass_functions.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import '../../../core/widgets/close_button.dart';
import '../../../router/router.dart';
import '../../map_detail/map_detail.dart';
import '../widgets/widgets.dart';

List<DistanceModel> distances = [
  DistanceModel(30.0, false, false, false),
  DistanceModel(100.0, false, false, false),
  DistanceModel(250.0, false, false, false),
];

class Compass extends ConsumerStatefulWidget {
  const Compass({super.key});

  @override
  ConsumerState<Compass> createState() => _CompassState();
}

class _CompassState extends ConsumerState<Compass> with WidgetsBindingObserver {
  bool isPlaceReached = false;
  bool isAppInBackgroundMode = false;
  double? heading;
  double? bearingToTarget;
  double distanceToTarget = 0;
  late Place pickedPlace;
  late StreamSubscription<CompassEvent> compassSubscription;
  late StreamSubscription<Position> positionStream;
  DatabaseService placesService = DatabaseService();
  Timer? _backgroundTimer;

  late double targetLat;
  late double targetLng;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCompass();
    _initializeLocationStream();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setPickedPlace();
  }

  void _setPickedPlace() {
  final pickedPlaceState = ref.watch(pickedPlaceProvider);
  String id = pickedPlaceState.placeId;

  if (id != 'null') {
    pickedPlace = ref.watch(placesProvider.notifier).getPlaceById(id);
    targetLat = pickedPlace.geoData.primary.coordinates[0];
    targetLng = pickedPlace.geoData.primary.coordinates[1];
  }
}


  void _initializeCompass() {
    compassSubscription = FlutterCompass.events!.listen((event) {
      if (mounted) {
        setState(() => heading = event.heading);
      }
    });
  }

  void _initializeLocationStream() {
    positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    )).listen(
      (position) {
        _updateDistanceAndBearing(position);
      },
      onError: (e) {
        dev.log('Error getting location: $e');
      },
    );
  }

  Future<void> _updateDistanceAndBearing(Position position) async {
    double distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, targetLat, targetLng);
    if (mounted) {
      setState(() {
        distanceToTarget = distance;
        dev.log('distance ${distanceToTarget}');
      });
    }
    bearingToTarget = calculateBearing(
        position.latitude, position.longitude, targetLat, targetLng);

    await checkDistance(distance);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    double direction =
        calculateCompassDirection(heading ?? 0, bearingToTarget ?? 0);

    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          BackgroundImage(
            image: 'assets/backgrounds/background_clouds.png',
          ),
          // Center the compass within the Stack
          Center(
            child: Container(
              width: 230.w,
              height: 230.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  const Radius.circular(120).r,
                ),
              ),
              child: Stack(
                children: [
                  BuildCompass(), // This should be the rotating compass image
                  Center(
                    child: Transform.rotate(
                      angle: (direction * (math.pi / 180)),
                      child: Image.asset(
                        "assets/compass-fixed.png",
                        scale: 1.1,
                        width: 200.w,
                        height: 300.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Keep Positioned for the Close_Button and Distance
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(screenType: ScreenType.detailMap,),
          ),
          Distance(
            distanceToTarget: this.distanceToTarget,
          ),
        ],
      ),
    );
  }

  checkDistance(double distance) async {
    if (distance > 250 || isPlaceReached) {
      distances.forEach((element) => element.updateActive(false));
      return;
    }
    if (distance <= 30 && !distances[0].isActive)
      distances[0].updateActive(true);
    else if ((distance > 30 && distance <= 100) && !distances[1].isActive)
      distances[1].updateActive(true);
    else if ((distance > 100 && distance <= 250) && !distances[2].isActive)
      distances[2].updateActive(true);

    if (isAppInBackgroundMode) {
      await notificateAboutDistance();
    } else {
      await handleDistanceOnForeground();
    }
  }

  notificateAboutDistance() async {
    distances.forEach((model) {
      if (model.isActive && !model.notificationSent) {
        if (model.distance <= 30) {
          NotificationService().sendNotification('Gratulujeme',
              'Dosiahli ste miesto, prejdite do aplikácie a získajte odmenu');
        } else {
          NotificationService().sendNotification('Pozor',
              'Zostáva už len trochu, choď ${model.distance.toStringAsFixed(0)} metrov a získaj odmenu.');
        }
        model.notificationSent = true;
      }
    });
  }

  handleDistanceOnForeground() async {
    var distance = distances.firstWhere((model) => model.isActive).distance;
    if (distance <= 30) {
      showCongratulationsDialog(context, pickedPlace.name);
      if (pickedPlace.isReached) {
        return;
      }
      this.isPlaceReached = true;
      await placesService.addPlaceToCollectedByUser(pickedPlace.id!);
      await initPlaces();
    }
  }

  initPlaces() async {
    final places = await DatabaseService().loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
    for (var place in places) {
      if (place.isReached) {
        dev.log('=> place ${place.name} is Collected = ${place.isReached}');
      }
    }
  }

  void backgroundServiceStart() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _initializeLocationStream();
        }
      });
    } else {
      await service.startService();
      backgroundServiceStart();
    }
  }

  void backgroundServiceStop() async {
    FlutterBackgroundService().invoke("stopService");
    dev.log('is running ${FlutterBackgroundService().isRunning()}');
  }

  void showCongratulationsDialog(
          BuildContext context, String pickedPlaceName) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CongratulationsDialog(pickedPlaceName: pickedPlaceName);
        },
      );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        isAppInBackgroundMode = false;
        if (_backgroundTimer?.isActive ?? false) {
          _backgroundTimer?.cancel();
        }
        backgroundServiceStop();
        dev.log("app in resumed");
        break;
      case AppLifecycleState.inactive:
        isAppInBackgroundMode = true;
        dev.log("app in inactive");
        break;
      case AppLifecycleState.paused:
        isAppInBackgroundMode = true;
        backgroundServiceStart();
        dev.log("app in paused");
        break;
      case AppLifecycleState.detached:
        isAppInBackgroundMode = true;
        dev.log("app in detached");
        break;
      case AppLifecycleState.hidden:
        isAppInBackgroundMode = true;
        dev.log('app is hidden');
        break;
    }
  }

  @override
  void dispose() {
    compassSubscription.cancel();
    positionStream.cancel();
    _backgroundTimer?.cancel();
    super.dispose();
  }
}

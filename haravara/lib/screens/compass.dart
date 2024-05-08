import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/notification_service.dart';
import 'package:haravara/services/places_service.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    // ignore: library_prefixes
    as geoLocation;

class Compass extends ConsumerStatefulWidget {
  const Compass({super.key});

  @override
  ConsumerState<Compass> createState() => _CompassState();
}

class DistanceModel {
  double distance;
  bool isActive;
  bool wasActive;
  bool notificationSent;

  DistanceModel(
      this.distance, this.isActive, this.wasActive, this.notificationSent);

  void updateActive(bool newActiveState) {
    if (this.isActive != newActiveState) {
      this.isActive = newActiveState;
      if (!newActiveState) {
        this.wasActive = false;
        this.notificationSent =
            false; // Reset notification flag when leaving zone
      }
    }
  }
}

class _CompassState extends ConsumerState<Compass> with WidgetsBindingObserver {
  List<DistanceModel> distances = [
    DistanceModel(30.0, false, false, false),
    DistanceModel(100.0, false, false, false),
    DistanceModel(250.0, false, false, false),
  ];
  bool isPlaceReached = false;
  bool isAppInBackgroundMode = false;
  double? heading;
  double? bearingToTarget;
  double distanceToTarget = 0;
  late Place pickedPlace;
  late StreamSubscription<CompassEvent> compassSubscription;
  late StreamSubscription<Position> positionStream;
  PlacesService placesService = PlacesService();
  Timer? _backgroundTimer;

  late double targetLat;
  late double targetLng;

  bool _isServiceRunning = false;

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
    String id = ref.watch(pickedPlaceProvider);
    pickedPlace = ref.watch(placesProvider.notifier).getPlaceById(id);
    targetLat = pickedPlace.geoData.primary.coordinates[0];
    targetLng = pickedPlace.geoData.primary.coordinates[1];
    // targetLat = 48.697555117540226;
    // targetLng = 21.23349319583468;
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
    bearingToTarget = _calculateBearing(
        position.latitude, position.longitude, targetLat, targetLng);

    await checkDistance(distance);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    double direction =
        calculateCompassDirection(heading ?? 0, bearingToTarget ?? 0);

    return Scaffold(
      endDrawer: const HeaderMenu(),
      body: Stack(
        children: [
          Image.asset(
            'assets/background_clouds.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8).h,
            child: Column(
              children: [
                const Header(
                    backButton: true,
                    backGroundColor: Color.fromARGB(255, 22, 102, 177)),
                40.verticalSpace,
                Container(
                  width: 230.w,
                  height: 230.h,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(const Radius.circular(120).r),
                  ),
                  child: Stack(children: [
                    Positioned(child: _buildCompass()),
                    Positioned(
                      child: Center(
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
                    )
                  ]),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                20.horizontalSpace,
                Image.asset(
                  'assets/mayka_shows.png',
                  width: 90.w,
                  height: 147.h,
                ),
                Container(
                  width: 117.w,
                  height: 43.h,
                  decoration: BoxDecoration(
                    color: getColorForDistance(this.distanceToTarget),
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                  ),
                  child: Center(
                    child: Text(
                      distanceToTarget > 1000
                          ? '${(distanceToTarget / 1000).toStringAsFixed(0)} KM'
                          : '${distanceToTarget.toStringAsFixed(0)} M',
                      style: GoogleFonts.titanOne(
                          color: Colors.white, fontSize: 24.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateBearing(
      double startLat, double startLng, double endLat, double endLng) {
    var startLatRad = _toRadians(startLat);
    var startLngRad = _toRadians(startLng);
    var endLatRad = _toRadians(endLat);
    var endLngRad = _toRadians(endLng);

    var dLng = endLngRad - startLngRad;

    var x = math.sin(dLng) * math.cos(endLatRad);
    var y = math.cos(startLatRad) * math.sin(endLatRad) -
        math.sin(startLatRad) * math.cos(endLatRad) * math.cos(dLng);

    var bearing = math.atan2(x, y);
    bearing = _toDegrees(bearing);
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  double _toDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  double calculateCompassDirection(double heading, double bearingToTarget) {
    double direction = bearingToTarget - heading;

    direction = (direction + 360) % 360;
    return direction;
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        double? currentDirection = snapshot.data!.heading;
        if (currentDirection == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }
        return Transform.rotate(
          angle: (currentDirection * (math.pi / 180) * -1),
          child: Image.asset(
            'assets/cadrant.jpg',
          ),
        );
      },
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
        model.notificationSent = true; // Set notification as sent
      }
    });
  }

  handleDistanceOnForeground() async {
    var distance = distances.firstWhere((model) => model.isActive).distance;
    if (distance <= 30) {
      showCustomDialog();
      if (pickedPlace.isReached) {
        return;
      }
      this.isPlaceReached = true;
      await placesService.addPlaceToCollectedByUser(pickedPlace.id!);
      await initPlaces();
    }
  }

  initPlaces() async {
    final places = await PlacesService().loadPlaces();
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

  showCustomDialog() {
    showCongratulationsDialog(context);
  }

  void showCongratulationsDialog(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double containerHeight = screenHeight / 2.3;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: containerHeight,
                  width: 224.w,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 140, 192, 225),
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      12.verticalSpace,
                      Text(
                        'GRATULUJEME!',
                        style: GoogleFonts.titanOne(
                            color: Colors.black, fontSize: 20.sp),
                      ),
                      12.verticalSpace,
                      Text(
                        'Dosiahli ste',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        '${pickedPlace.name}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                            color: Colors.black, fontSize: 15.sp),
                      ),
                      30.verticalSpace,
                      Container(
                        width: 100.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 22, 102, 177),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        child: TextButton(
                          child: Text(
                            'Získať pečiatku',
                            style: GoogleFonts.titanOne(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   bottom: -100,
                //   left: 0,
                //   right: 0,
                //   child: Center(
                //     child: Image.asset(
                //       "assets/MaxAndMayka.jpg",
                //       scale: 1.1,
                //       width: 255.w,
                //       height: 255.h,
                //     ),
                //   ),
                // ),
              ],
            ),
          );
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

  getColorForDistance(double distance) {
    if (distance > 250) {
      return const Color.fromARGB(255, 70, 68, 205);
    }
    if (distance < 25) return Color.fromARGB(255, 233, 18, 18);
    if (distance < 100) return Color.fromARGB(255, 225, 222, 16);
    return Color.fromARGB(255, 215, 16, 246);
  }

  @override
  void dispose() {
    compassSubscription.cancel();
    positionStream.cancel();
    _backgroundTimer?.cancel();
    super.dispose();
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';

class Compass extends ConsumerStatefulWidget {
  const Compass({super.key});

  @override
  ConsumerState<Compass> createState() => _CompassState();
}

class _CompassState extends ConsumerState<Compass> {
  double? heading;
  late StreamSubscription<CompassEvent> compassSubscription;
  double? bearingToTarget;
  double distanceToTarget = 0;
  late Place pickedPlace;
  late StreamSubscription<Position> positionStream;

  late double targetLat;
  late double targetLng;

  @override
  void initState() {
    super.initState();
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
  }

  void _initializeCompass() {
    compassSubscription = FlutterCompass.events!.listen((event) {
      setState(() => heading = event.heading);
    });
  }

  void _initializeLocationStream() {
    positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    )).listen(
      (position) {
        _updateDistanceAndBearing(position);
      },
      onError: (e) {},
    );
  }

  Future<void> _updateDistanceAndBearing(Position position) async {
    bearingToTarget = _calculateBearing(
        position.latitude, position.longitude, targetLat, targetLng);
    double distance = await calculateDistance(
      position.latitude,
      position.longitude,
      targetLat,
      targetLng,
    );
    setState(() {
      distanceToTarget = distance;
    });
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
                    color: const Color.fromARGB(255, 70, 68, 205),
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
    // print('pos direction ${(direction * (math.pi / 180))}');
    return direction;
  }

  Future<double> calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters;
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
        // print('current direction ${(currentDirection * (math.pi / 180) * -1)}');
        return Transform.rotate(
          angle: (currentDirection * (math.pi / 180) * -1),
          child: Image.asset(
            'assets/cadrant.jpg',
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    compassSubscription.cancel();
    positionStream.cancel();
    super.dispose();
  }
}

//  Center(
//                       child: Transform.rotate(
//                         angle: (direction * (math.pi / 180)),
//                         child: Image.asset(
//                           "assets/compass-fixed.png",
//                           scale: 1.1,
//                         ),
//                       ),
//                     ),
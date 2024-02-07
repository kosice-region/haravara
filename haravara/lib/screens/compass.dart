import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haravara/widgets/header.dart';

class Compass extends StatefulWidget {
  const Compass({super.key});

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  double? heading = 0;
  late StreamSubscription<CompassEvent> compassSubscription;
  double? bearingToTarget;

  @override
  void initState() {
    super.initState();
    _initializeCompass();
    _setBearingToTarget();
  }

  void _initializeCompass() {
    compassSubscription = FlutterCompass.events!.listen((event) {
      setState(() {
        heading = event.heading;
      });
    });
  }

  Future<void> _setBearingToTarget() async {
    double targetLat = 48.69703247300475;
    double targetLng = 21.231576007988867;

    Position position = await _getCurrentLocation();
    bearingToTarget = _calculateBearing(
        position.latitude, position.longitude, targetLat, targetLng);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    double direction =
        calculateCompassDirection(heading ?? 0, bearingToTarget ?? 0);

    print(direction);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/clouds.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8).h,
            child: Column(
              children: [
                const Header(backGroundColor: Color.fromARGB(255, 70, 68, 205)),
                40.verticalSpace,
                Container(
                  width: 230.w,
                  height: 230.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 144, 198, 238),
                    borderRadius:
                        BorderRadius.all(const Radius.circular(120).r),
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0.w,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(
                      bottom: 1.h,
                      top: 1.h,
                      right: 1.w,
                      left: 1.w,
                      child: Image.asset("assets/cadrant.png"),
                    ),
                    Center(
                      child: Transform.rotate(
                        angle: (direction * (pi / 180)),
                        child: Image.asset(
                          "assets/compass.png",
                          scale: 1.1,
                        ),
                      ),
                    )
                  ]),
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

    var x = sin(dLng) * cos(endLatRad);
    var y = cos(startLatRad) * sin(endLatRad) -
        sin(startLatRad) * cos(endLatRad) * cos(dLng);

    var bearing = atan2(x, y);
    bearing = _toDegrees(bearing);
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  double _toDegrees(double radians) {
    return radians * 180 / pi;
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  double calculateCompassDirection(double heading, double bearingToTarget) {
    double direction = bearingToTarget - heading;

    direction = (direction + 360) % 360;

    return direction;
  }
}

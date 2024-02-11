import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';

class Compass extends StatefulWidget {
  const Compass({super.key, required this.targetLocation});

  final LatLng targetLocation;

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  double? heading;
  late StreamSubscription<CompassEvent> compassSubscription;
  double? bearingToTarget;
  double distanceToTarget = 0;
  late StreamSubscription<Position> positionStream;

  late double targetLat;
  late double targetLng;

  @override
  void initState() {
    super.initState();
    targetLat = widget.targetLocation.latitude;
    targetLng = widget.targetLocation.longitude;
    _initializeCompass();
    _initializeLocationStream();
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
      distanceFilter: 5,
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
      endDrawer: const HeaderMenu(
        backGroundColor: Color.fromARGB(255, 70, 68, 205),
      ),
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
                    ),
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

  @override
  void dispose() {
    compassSubscription.cancel();
    positionStream.cancel();
    super.dispose();
  }
}

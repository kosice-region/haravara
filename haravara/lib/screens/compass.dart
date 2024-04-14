import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;
import 'dart:math';

import 'package:haravara/services/location_client.dart';
import 'package:location/location.dart';
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

class Compass extends ConsumerStatefulWidget {
  const Compass({super.key});

  @override
  ConsumerState<Compass> createState() => _CompassState();
}

class _CompassState extends ConsumerState<Compass> with WidgetsBindingObserver {
  bool isPlaceReached = false;
  double? heading;
  double? bearingToTarget;
  double distanceToTarget = 0;
  late Place pickedPlace;
  late StreamSubscription<CompassEvent> compassSubscription;
  late StreamSubscription<LocationData> locationSubscription;
  Location location = Location();
  final _locationClient = LocationClient();

  late double targetLat;
  late double targetLng;

  bool _isServiceRunning = false;

  @override
  void initState() {
    super.initState();
    _locationClient.init();
    _listenLocation();
    Timer.periodic(const Duration(seconds: 2), (_) => _listenLocation());
    WidgetsBinding.instance.addObserver(this);
    _initializeCompass();
    _initializeLocationStream();
  }

  void _listenLocation() async {
    if (!_isServiceRunning && await _locationClient.isServiceEnabled()) {
      _isServiceRunning = true;
      _locationClient.locationStream.listen((event) {
        dev.log(event.toString());
      });
    } else {
      _isServiceRunning = false;
    }
  }

  notificateAboutDistance(double distance) async {
    if (distance <= 25) {
      NotificationService().sendNotification('Gratulujeme',
          'Dosiahli ste miesto, prejdite do aplikácie a získajte odmenu');
      // await placesService.addPlaceToCollectedByUser(pickedPlace.id!);
    } else {
      NotificationService().sendNotification('Pozor',
          'Zostáva už len trochu, choď ${distance.toStringAsFixed(0)} metrov a získaj odmenu.');
    }
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
      setState(() => heading = event.heading);
    });
  }

  void _initializeLocationStream() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      _updateDistanceAndBearing(currentLocation);
    });
  }

  Future<void> _updateDistanceAndBearing(LocationData currentLocation) async {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      bearingToTarget = _calculateBearing(currentLocation.latitude!,
          currentLocation.longitude!, targetLat, targetLng);

      double distance = await calculateDistance(
        currentLocation.latitude!,
        currentLocation.longitude!,
        targetLat,
        targetLng,
      );

      setState(() {
        distanceToTarget = distance;
      });
    }
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
    return direction;
  }

  Future<double> calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    var earthRadiusKm = 6371.0;

    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    var distance = earthRadiusKm * c;
    return distance * 1000; // Convert to meters
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

  @override
  void dispose() {
    compassSubscription.cancel();
    locationSubscription.cancel();
    super.dispose();
  }
}

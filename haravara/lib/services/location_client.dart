// import 'dart:developer';

// import 'package:location/location.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationClient {
//   final Location _location = Location();

//   // Stream that emits LatLng values as the location updates.
//   Stream<LatLng> get locationStream => _location.onLocationChanged
//       .map((event) => LatLng(event.latitude!, event.longitude!));

//   void init() async {
//     await requestPermission();
//   }

//   Future<bool> isServiceEnabled() async {
//     return _location.serviceEnabled();
//   }

//   Future<void> requestPermission() async {
//     await Permission.location.request();
//     var status = await Permission.locationAlways.status;
//     if (status.isDenied || status.isPermanentlyDenied) {
//       await Permission.locationAlways.request();
//     }
//     status = await Permission.locationAlways.status;
//     if (status.isGranted) {
//       print("Location Always permission granted.");
//     } else if (status.isPermanentlyDenied) {
//       // Opens the app settings if permissions are permanently denied.
//       openAppSettings();
//     } else {
//       print("Location Always permission denied.");
//     }
//   }
// }

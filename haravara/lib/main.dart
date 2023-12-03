import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:haravara/screens/google_map_screen.dart';
import 'package:haravara/screens/main_screen.dart';
import 'package:haravara/widgets/under_map.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();
  if (status.isGranted) {
  } else if (status.isDenied) {
    requestLocationPermission();
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: const GoogleMapScreen(),
      // home: AuthScreen(),
    );
  }
}

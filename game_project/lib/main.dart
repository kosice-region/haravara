import 'package:flutter/material.dart';
import 'package:game_project/screens/google_map_screen.dart';
import 'package:game_project/screens/main_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();
  if (status.isGranted) {
    // Location permission is granted. You can proceed with location-related tasks.
  } else if (status.isDenied) {
    // Location permission is denied. You can handle this case by showing a dialog or explanation to the user.
    requestLocationPermission();
  } else if (status.isPermanentlyDenied) {
    // Location permission is permanently denied. You can open app settings to allow the user to enable it manually.
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
      home: MainScreen('1', true),
      // home: AuthScreen(),
    );
  }
}
// void _locationFunctions() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print(position);
//     final lat = position.latitude;
//     final lng = position.longitude;
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCgHVN9XIIgGyCxlDYvOloDIkEcArxMkRw');
//     final response = await http.get(url);
//     final resData = json.decode(response.body);
//     final address = resData['results'][0]['formatted_address'];
//   }

//  final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCgHVN9XIIgGyCxlDYvOloDIkEcArxMkRw');
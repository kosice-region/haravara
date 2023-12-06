import 'package:flutter/material.dart';
import 'package:haravara/screens/google_map_screen.dart';
import 'package:haravara/screens/google_map_second_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      // home: const GoogleMapScreen(),
      home: const GoogleMapSecondScreen(),
    );
  }
}

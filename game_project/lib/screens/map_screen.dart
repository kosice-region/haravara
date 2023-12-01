import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_project/widgets/info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isShown = false;
  void _switchTInfo() {
    print(isShown);
    setState(() {
      isShown = !isShown;
    });
    print(isShown);
  }

  void _locationFunctions() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    final lat = position.latitude;
    final lng = position.longitude;
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCgHVN9XIIgGyCxlDYvOloDIkEcArxMkRw');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walking'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/Map.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 370,
            left: 50,
            bottom: 0,
            right: 20,
            child: TextButton(
              onPressed: () {
                _locationFunctions();
                _switchTInfo();
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    Colors.transparent), // No overlay color
                textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.black)), // Text color
              ),
              child: const Text(''),
            ),
          ),
          if (isShown)
            const Positioned(
              child: InfoWiget(),
            ),
        ],
      ),
    );
  }
}

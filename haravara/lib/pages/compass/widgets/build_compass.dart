import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class BuildCompass extends StatefulWidget {
  const BuildCompass({super.key});

  @override
  State<BuildCompass> createState() => _BuildCompassState();
}

class _BuildCompassState extends State<BuildCompass> {
  @override
  Widget build(BuildContext context) {
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
}

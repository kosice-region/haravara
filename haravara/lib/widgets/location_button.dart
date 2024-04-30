import 'package:flutter/material.dart';
import 'package:haravara/models/location_places.dart';

class LocationButton extends StatelessWidget {
  const LocationButton(
      {super.key, required this.locationPlace, required this.onPressed});

  final LocationPlaces locationPlace;
  final void Function(LocationPlaces) onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // background (button) color
        foregroundColor: Colors.black, // foreground (text) color
      ),
      onPressed: () {
        onPressed(locationPlace); // Pass the locationName
      },
      child: Text(locationPlace.locationName),
    );
  }
}

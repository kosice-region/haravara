import 'dart:io';
import 'package:haravara/core/models/place.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:flutter/cupertino.dart';

class MapService {
  Future<void> launchMap(BuildContext context, Place place) async {
    mapLauncher.MapType selectedMap = mapLauncher.MapType.apple;

    if (Platform.isIOS) {
      String? selected = await showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Choose Map'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Google Maps'),
              onPressed: () => Navigator.pop(context, 'Google Maps'),
            ),
            CupertinoActionSheetAction(
              child: const Text('Apple Maps'),
              onPressed: () => Navigator.pop(context, 'Apple Maps'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ),
      );

      if (selected == 'Google Maps') {
        selectedMap = mapLauncher.MapType.google;
      } else if (selected == 'Apple Maps') {
        selectedMap = mapLauncher.MapType.apple;
      } else {
        return; // Ak zruší, neotvára mapu
      }
    } else if (Platform.isAndroid) {
      selectedMap = mapLauncher.MapType.google;
    }

    // Skontroluj, či je mapa dostupná
    bool isAvailable = await mapLauncher.MapLauncher.isMapAvailable(selectedMap) ?? false;
    if (!isAvailable) {
      print("Selected map is not available.");
      return;
    }

    // Otvorenie mapy
    await mapLauncher.MapLauncher.showMarker(
      mapType: selectedMap,
      coords: mapLauncher.Coords(
        place.geoData.primary.coordinates[0],
        place.geoData.primary.coordinates[1],
      ),
      title: place.name,
    );
  }
}

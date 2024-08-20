import 'dart:io';
import 'package:haravara/core/models/place.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:flutter/cupertino.dart';
import 'package:map_launcher/map_launcher.dart';

class MapService {
  launchMap(BuildContext context, Place place) async {
    mapLauncher.MapType map = mapLauncher.MapType.apple;
    bool isMapSelected = false;

    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Choose Map'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Google Maps'),
              onPressed: () {
                Navigator.pop(context, 'Google Maps');
                map = mapLauncher.MapType.google;
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Apple Maps'),
              onPressed: () {
                Navigator.pop(context, 'Apple Maps');
                map = mapLauncher.MapType.apple;
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              isMapSelected = false;
            },
            child: const Text('Cancel'),
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      map = mapLauncher.MapType.google;
      isMapSelected = true;
    }
    if (isMapSelected) {
      await MapLauncher.showMarker(
        mapType: map,
        coords: Coords(place.geoData.primary.coordinates[0],
            place.geoData.primary.coordinates[1]),
        title: place.name,
      );
    }
  }
}

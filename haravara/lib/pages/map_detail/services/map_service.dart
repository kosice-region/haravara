import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:haravara/core/models/place.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapService {
  Future<void> launchMap(BuildContext context, Place place) async {
    if (Platform.isAndroid) {
      final availableMaps = await mapLauncher.MapLauncher.installedMaps;

      final mapOptions = availableMaps.where((map) {
        return map.mapType == mapLauncher.MapType.google ||
            map.mapType == mapLauncher.MapType.mapyCz;
      }).map((map) {
        if (map.mapType == mapLauncher.MapType.google) {
          return mapLauncher.AvailableMap(
            mapName: 'Google Mapy',
            mapType: map.mapType,
            icon: map.icon,
          );
        } else if (map.mapType == mapLauncher.MapType.mapyCz) {
          return mapLauncher.AvailableMap(
            mapName: 'Mapy.cz',
            mapType: map.mapType,
            icon: map.icon,
          );
        }
        return map;
      }).toList();

      if (mapOptions.isEmpty) {
        log("No supported maps installed.", name: "MapService");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Žiadne podporované mapy nie sú nainštalované')),
        );
        return;
      }

      if (mapOptions.length == 1) {
        _launchSelectedMap(mapOptions.first, place);
        return;
      }

      _showAndroidMapPicker(context, mapOptions, place);
    } else if (Platform.isIOS) {
      mapLauncher.MapType selectedMap = mapLauncher.MapType.apple;

      String? selected = await showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Vyberte mapu'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Google Mapy'),
              onPressed: () => Navigator.pop(context, 'Google Mapy'),
            ),
            CupertinoActionSheetAction(
              child: const Text('Mapy.cz'),
              onPressed: () => Navigator.pop(context, 'Mapy.cz'),
            ),
            CupertinoActionSheetAction(
              child: const Text('Apple Mapy'),
              onPressed: () => Navigator.pop(context, 'Apple Mapy'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, 'Zrušiť'),
            child: const Text('Zrušiť'),
          ),
        ),
      );

      if (selected == 'Google Mapy') {
        selectedMap = mapLauncher.MapType.google;
      } else if (selected == 'Mapy.cz') {
        selectedMap = mapLauncher.MapType.mapyCz;
      } else if (selected == 'Apple Mapy') {
        selectedMap = mapLauncher.MapType.apple;
      } else {
        return;
      }

      bool isAvailable =
          await mapLauncher.MapLauncher.isMapAvailable(selectedMap) ?? false;
      if (!isAvailable) {
        log("Selected map ($selected) is not available.", name: "MapService");
        return;
      }

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

  void _showAndroidMapPicker(
      BuildContext context, List<mapLauncher.AvailableMap> maps, Place place) {
    for (var map in maps) {
      log("${map.mapName} icon path: ${map.icon}", name: "MapService");
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 35.w,
                  height: 3.h,
                  margin: EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: maps.asMap().entries.map((entry) {
                    final map = entry.value;
                    final iconPath = map.icon.isNotEmpty
                        ? map.icon.replaceFirst('packages/map_launcher/', '')
                        : null;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _launchSelectedMap(map, place);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: iconPath != null
                                      ? SvgPicture.asset(
                                          iconPath,
                                          package: 'map_launcher',
                                          width: 60.w,
                                          height: 60.h,
                                          fit: BoxFit.contain,
                                          placeholderBuilder: (context) => Icon(
                                            Icons.map,
                                            size: 40.sp,
                                            color: Colors.grey,
                                          ),
                                          semanticsLabel: '${map.mapName} icon',
                                        )
                                      : Icon(
                                          Icons.map,
                                          size: 40.sp,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                map.mapName,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'Zrušiť',
                          style: GoogleFonts.titanOne(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchSelectedMap(
      mapLauncher.AvailableMap map, Place place) async {
    bool isAvailable =
        await mapLauncher.MapLauncher.isMapAvailable(map.mapType) ?? false;
    if (!isAvailable) {
      log("${map.mapName} is not available.", name: "MapService");
      return;
    }

    await map.showMarker(
      coords: mapLauncher.Coords(
        place.geoData.primary.coordinates[0],
        place.geoData.primary.coordinates[1],
      ),
      title: place.name,
    );
  }
}

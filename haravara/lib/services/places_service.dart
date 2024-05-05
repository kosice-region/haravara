import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/repositories/location_repository.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
final locationRepository = LocationRepository();

Future<Directory> _getDirectory() async {
  Directory appDocDir = await syspaths.getApplicationDocumentsDirectory();
  return appDocDir;
}

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE if not exists places(
           id TEXT PRIMARY KEY,
           name TEXT,
           created INTEGER,
           updated INTEGER,
           active INTEGER,
           isReached INTEGER,
           description TEXT,
           radius INTEGER,
           lat_primary REAL,
           lng_primary REAL,
           xCoordinate REAL,
           yCoordinate REAL,
           location_path TEXT,
           stamp_path TEXT)''');
    },
    version: 1,
  );
  return db;
}

class PlacesService {
  Future<void> savePlacesLocally() async {
    final List<Place> places = await locationRepository.getAllPlaces();
    Directory appDocDir = await _getDirectory();
    await _downloadLocationDataFromStorage(places);
    final db = await _getDatabase();
    for (final place in places) {
      await db.insert(
        'places',
        {
          'id': place.id!,
          'name': place.name,
          'created': place.created,
          'updated': place.updated,
          'active': place.active ? 1 : 0,
          'isReached': 0,
          'description': place.detail.description,
          'radius': place.geoData.primary.fence.radius,
          'lat_primary': place.geoData.primary.coordinates[0],
          'lng_primary': place.geoData.primary.coordinates[1],
          'xCoordinate': place.geoData.primary.pixelCoordinates[0],
          'yCoordinate': place.geoData.primary.pixelCoordinates[1],
          'location_path': '${appDocDir.path}/${place.placeImages!.location}',
          'stamp_path': '${appDocDir.path}/${place.placeImages!.stamp}',
        },
      );
    }
  }

  Future<void> _downloadLocationDataFromStorage(List<Place> places) async {
    Directory appDocDir = await _getDirectory();
    List<PlaceImageFromDB> images = places
        .where((place) => place.placeImages != null)
        .map((place) => place.placeImages!)
        .toList();

    for (final image in images) {
      String fileToDownloadLocationImage = image.location;
      String fileToDownloadStampImage = image.stamp;
      try {
        print('downloading');
        final locationUrl = await firebase_storage.FirebaseStorage.instance
            .ref(fileToDownloadLocationImage)
            .getDownloadURL();
        final stampUrl = await firebase_storage.FirebaseStorage.instance
            .ref(fileToDownloadStampImage)
            .getDownloadURL();
        await Dio()
            .download(locationUrl, '${appDocDir.path}/${image.location}');
        await Dio().download(stampUrl, '${appDocDir.path}/${image.stamp}');
      } catch (e) {
        print('Download error: $e');
      }
    }
  }

  Future<void> addPlaceToCollectedByUser(String id) async {
    await locationRepository.addCollectedPlaceForUser(id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? collectedPlaces = prefs.getStringList('collectedPlaces');
    log('Collected Places from service ${collectedPlaces}');

    if (collectedPlaces == null) {
      collectedPlaces = [id];
    } else {
      collectedPlaces.add(id);
    }

    log('Collected Places from service 2 ${collectedPlaces}');
    await setReachedPlace(id);
    prefs.setStringList('collectedPlaces', collectedPlaces);
    log('Collected Places from service 3 ${await prefs.getStringList('collectedPlaces')}');
  }

  Future<void> getCollectedPlacesByUser(String id) async {
    final collectedPlaces =
        await locationRepository.getCollectedPlacesByUser(id);
    log('collected places ${collectedPlaces}');

    for (String placeId in collectedPlaces) {
      await setReachedPlace(placeId);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('collectedPlaces', collectedPlaces);
    log('places from prefs ${prefs.getStringList('collectedPlaces')}');
  }

  Future<void> setReachedPlace(String placeId) async {
    final db = await _getDatabase();
    await db.update(
      'places',
      {'isReached': 1},
      where: 'id = ?',
      whereArgs: [placeId],
    );
  }

  Future<void> clearRichedPlaces() async {
    final db = await _getDatabase();
    await db.update(
      'places',
      {'isReached': 0},
    );
  }

  Future<List<Place>> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('places');

    final List<Place> places = data.map<Place>((row) {
      GeoData geoData = GeoData(
        primary: Primary(
          coordinates: [
            row['lat_primary'] as double,
            row['lng_primary'] as double
          ],
          fence: Fence(radius: row['radius'] as int),
          pixelCoordinates: [
            row['xCoordinate'] as double,
            row['yCoordinate'] as double
          ],
        ),
      );
      Detail detail = Detail(description: row['description'] as String);
      PlaceImageFromDB images = PlaceImageFromDB(
          location: row['location_path'] as String,
          stamp: row['stamp_path'] as String,
          placeId: row['id'] as String);

      return Place(
        id: row['id'] as String,
        active: row['active'] == 1,
        isReached: row['isReached'] == 1,
        created: row['created'] as int,
        detail: detail,
        geoData: geoData,
        name: row['name'] as String,
        updated: row['updated'] as int,
        placeImages: images,
      );
    }).toList();
    return places;
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results =
        await storage.ref('images/locations/').listAll();

    firebase_storage.ListResult results2 =
        await storage.ref('images/stamps/').listAll();

    for (var ref in results.items) {
      print('file  $ref');
    }
    for (var ref in results2.items) {
      print('file  $ref');
    }
    return results;
  }

  void deleteDB() async {
    final db = await _getDatabase();
    db.delete('places');
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:haravara/models/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference placesRef = FirebaseDatabase.instance.ref('locations');
DatabaseReference imagesToPlacesRef = FirebaseDatabase.instance.ref('images');

class LocationRepository {
  final dio = Dio();

  Future<List<Place>> getAllPlaces() async {
    DataSnapshot placesSnapshot = await placesRef.get();
    DataSnapshot imagesSnapshot = await imagesToPlacesRef.get();
    final placesJson = decodeJsonFromSnapshot(placesSnapshot);
    final imagesJson = decodeJsonFromSnapshot(imagesSnapshot);

    List<Place> places = [];
    placesJson.forEach((key, value) {
      try {
        Map<String, dynamic> placeMap = value as Map<String, dynamic>;
        Map<String, dynamic>? imageMap =
            imagesJson[key] as Map<String, dynamic>?;
        PlaceImageFromDB imageFromDB =
            PlaceImageFromDB.fromJson(imageMap!).copyWith(placeId: key);
        Place place = Place.fromJson(placeMap)
            .copyWith(id: key, placeImages: imageFromDB);
        places.add(place);
      } catch (e) {
        print('Error parsing place data for key $key: $e');
      }
    });
    return places;
  }

  Future<void> addCollectedPlaceForUser(String placeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    if (userId != null && placeId.isNotEmpty) {
      DatabaseReference placesRef =
          FirebaseDatabase.instance.ref('collectedLocationsByUsers');

      var places = prefs.getStringList('collectedPlaces');
      log('places before $places');
      if (places == null) {
        places = [placeId];
      } else {
        places = [...places, placeId];
      }
      log('places after $places');
      await placesRef.update({userId: places});
    }
  }

  Future<List<String>> getCollectedPlacesByUser(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('collectedLocationsByUsers/$userId');

    DataSnapshot snapshot = await userRef.get();

    List<dynamic>? placesDynamic = snapshot.value as List<dynamic>?;

    if (placesDynamic != null) {
      List<String> collectedPlaces = placesDynamic.cast<String>();
      print(collectedPlaces);
      return collectedPlaces;
    } else {
      return [];
    }
  }

  static Map<String, dynamic> decodeJsonFromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> dataFromSnapshot =
        snapshot.value as Map<dynamic, dynamic>;
    final jsonString = json.encode(dataFromSnapshot);
    final jsonToReturn = json.decode(jsonString) as Map<String, dynamic>;
    return jsonToReturn;
  }
}

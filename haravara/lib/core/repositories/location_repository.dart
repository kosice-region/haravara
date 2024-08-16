import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference placesRef = FirebaseDatabase.instance.ref('locations');
DatabaseReference avatarsRef = FirebaseDatabase.instance.ref('avatars');
DatabaseReference imagesToPlacesRef = FirebaseDatabase.instance.ref('images');

class LocationRepository {
  final dio = Dio();

  Future<List<UserAvatar>> getAllAvatars() async {
    DataSnapshot avatarsSnapshot = await avatarsRef.get();
    final avatarsJson = decodeJsonFromSnapshot(avatarsSnapshot);
    List<UserAvatar> avatars = [];
    avatarsJson.forEach((key, value) {
      try {
        Map<String, dynamic>? imageMap =
            avatarsJson[key] as Map<String, dynamic>?;
        UserAvatar imageFromDB =
            UserAvatar.fromJson(imageMap!).copyWith(id: key);
        avatars.add(imageFromDB);
      } catch (e) {
        print('Error parsing place data for key $key: $e');
      }
    });
    return avatars;
  }

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
      if (places == null) {
        places = [placeId];
      } else {
        places = [...places, placeId];
      }
      await placesRef.update({userId: places});
    }
  }

  Future<List<String>> getCollectedPlacesByUser(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('collectedLocationsByUsers/$userId');

    DataSnapshot snapshot = await userRef.get();
    if (snapshot.value == null) {
      log('No data available for user $userId');
      return [];
    }

    if (snapshot.value is List) {
      List<dynamic> placesDynamic = snapshot.value as List;
      List<String> collectedPlaces = placesDynamic.whereType<String>().toList();
      log('$collectedPlaces');
      return collectedPlaces;
    } else {
      log('Unexpected data format for user $userId: ${snapshot.value}');
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

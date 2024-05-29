import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference placesRef = FirebaseDatabase.instance.ref('locations');
DatabaseReference avatarsRef = FirebaseDatabase.instance.ref('avatars');
DatabaseReference imagesToPlacesRef = FirebaseDatabase.instance.ref('images');

class DatabaseRepository {
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
        log('Error parsing place data for key $key: $e');
      }
    });
    return avatars;
  }

  Future<void> uploadUserAvatar(
      File image, String userId, String imageId, String mimeType) async {
    var userAvatarsRef = await getUserAvatarsReference(userId, imageId);
    try {
      await userAvatarsRef.putFile(
          image, SettableMetadata(contentType: mimeType));
    } on FirebaseException catch (e) {
      log('error while adding avatar for user $userId -> $e');
    }
  }

  Future<void> deleteAvatar(String userId, String imageId) async {
    var userAvatarsRef = await getUserAvatarsReference(userId, imageId);
    try {
      await userAvatarsRef.delete();
    } on FirebaseException catch (e) {
      log('error while deleting avatar for user $userId -> $e');
    }
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
      return collectedPlaces;
    } else {
      log('Unexpected data format for user $userId: ${snapshot.value}');
      return [];
    }
  }

  Future<Reference> getUserAvatarsReference(
      String userId, String imageId) async {
    return FirebaseStorage.instance
        .ref()
        .child('images/users-avatars/$userId/$imageId');
  }

  Future<String?> getFileNameWithExtension(File file) async {
    if (await file.exists()) {
      return path.basename(file.path);
    } else {
      return null;
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

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference placesRef = FirebaseDatabase.instance.ref('locations');
DatabaseReference avatarsRef = FirebaseDatabase.instance.ref('avatars');
DatabaseReference imagesToPlacesRef = FirebaseDatabase.instance.ref('images');
DatabaseReference usernameRef = database.ref('usernames');


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
        print('Error parsing place data for key $key: $e');
      }
    });
    return avatars;
  }

  Future<void> uploadUserAvatar(
      File image, String userId, String imageId) async {
    var userAvatarsRef = FirebaseStorage.instance
        .ref()
        .child('images/users-avatars/$userId/$imageId.jpg');
    try {
      await userAvatarsRef.putFile(image);
    } on FirebaseException catch (e) {
      log('error while adding avatar $e');
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
      log('$collectedPlaces');
      return collectedPlaces;
    } else {
      log('Unexpected data format for user $userId: ${snapshot.value}');
      return [];
    }
  }



  Future<bool> isUserNameUsed(String username) async {
    DataSnapshot snapshot = await usernameRef.orderByChild('username').equalTo(username).get();

    if (snapshot.exists && snapshot.value != null) {
      return true;
    }
    return false;


  }

  Future<bool> removeUserCompletely(String userIdToRemove) async {
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;

    // Input validation (basic check)
    if (userIdToRemove.isEmpty) {
      print("Error: User ID cannot be empty.");
      return false;
    }

    print("--- WARNING: Attempting to permanently delete user: $userIdToRemove ---");

    String? userEmail;
    String? base64Email;

    try {
      // 1. Try to get the user's email first to remove hash entries
      final userRef = _database.ref('users/$userIdToRemove');
      final DataSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists && userSnapshot.value != null) {
        Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
        if (userData != null && userData.containsKey('email')) {
          userEmail = userData['email'] as String?;
          if (userEmail != null) {

            base64Email = generateBase64(userEmail);
            print("Found email: $userEmail, Base64: $base64Email for user $userIdToRemove");
          } else {
            print("User node exists for $userIdToRemove but email field is missing or null.");
          }
        } else {
          print("User node exists for $userIdToRemove but email field is missing.");
        }
      } else {
        print("User node 'users/$userIdToRemove' does not exist. Cannot fetch email.");
      }

      List<DatabaseReference> refsToRemove = [];

      // Primary user data
      refsToRemove.add(_database.ref('users/$userIdToRemove'));

      // Username mapping
      refsToRemove.add(_database.ref('usernames/$userIdToRemove'));

      // Collected locations
      refsToRemove.add(_database.ref('collectedLocationsByUsers/$userIdToRemove'));

      // Active rewards
      refsToRemove.add(_database.ref('userRewards/activeRewards/$userIdToRemove'));

      // Claimed rewards (Optional: decide if you want to keep this history)
      refsToRemove.add(_database.ref('userRewards/claimedRewards/$userIdToRemove'));


      // Images
      final ListResult result = await _storage.ref("images/users-avatars/$userIdToRemove").listAll();
      for (final Reference ref in result.items) {
        print("Deleting from Storage: ${ref.fullPath}");
        await ref.delete();
      }

      // Email hash lookups (if email was found)
      if (base64Email != null) {
        refsToRemove.add(_database.ref('userHashes/$base64Email'));
        refsToRemove.add(_database.ref('userIds/$base64Email'));
      } else {
        print("Skipping removal of userHashes/userIds for $userIdToRemove because email/base64Email could not be determined.");
      }


      // 3. Perform deletions
      for (DatabaseReference ref in refsToRemove) {
        print("Attempting to remove: ${ref.path}");
        // Check if the node actually exists before trying to remove (optional, remove() doesn't fail if path non-existent)
        // final checkSnapshot = await ref.get();
        // if (checkSnapshot.exists) {
        await ref.remove();
        print("Removed: ${ref.path}");
        // } else {
        //    print("Skipped (already non-existent): ${ref.path}");
        // }
      }

      print("--- User removal process completed for: $userIdToRemove ---");
      return true; // Indicate success
    } catch (e) {
      print("--- Error removing user $userIdToRemove: $e ---");
      // Handle the error appropriately (e.g., log it, show a message)
      return false; // Indicate failure
    }
  }

  Future<String> getUserIdByEmail(String email) async {
    final usersRef = FirebaseDatabase.instance.ref('users');
    final snapshot = await usersRef.orderByChild('email').equalTo(email).get();
    if (snapshot.exists && snapshot.children.isNotEmpty) {
      final userKey = snapshot.children.first.key;

      if (userKey != null) {
        return userKey;
      } else {
        throw Exception('Found user for email $email, but failed to retrieve user ID (key was null).');
      }
    } else {
      throw Exception('User not found for email: $email');
    }
  }

  String generateBase64(String input) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(input);
  }


  static Map<String, dynamic> decodeJsonFromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> dataFromSnapshot =
        snapshot.value as Map<dynamic, dynamic>;
    final jsonString = json.encode(dataFromSnapshot);
    final jsonToReturn = json.decode(jsonString) as Map<String, dynamic>;
    return jsonToReturn;
  }
}



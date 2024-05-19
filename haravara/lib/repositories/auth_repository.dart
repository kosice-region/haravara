import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:haravara/models/user.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference usersRef = database.ref('users');
DatabaseReference usersIdsRef = database.ref('userIds');

class AuthRepository {
  Future<void> registerUser(User user, String id, String base64) async {
    final userToRegister = database.ref('users/$id');
    await userToRegister.set({
      'username': user.username,
      'email': user.email ?? 'null',
      'phone_ids': json.encode(user.phones),
      'phone_number': user.phoneNumber ?? 'null',
      'profile': {
        'avatar': user.userProfile!.avatar,
        'type': user.userProfile!.profileType.toString(),
      }
    });
    final newUsersIdRef = database.ref('userIds/$base64');
    newUsersIdRef.set(id);
  }

  Future<User> getUserById(String userId) async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    DataSnapshot snapshot = await usersRef.child(userId).get();

    if (!snapshot.exists) {
      throw Exception('User not found');
    }
    final userJson = decodeJsonFromSnapshot(snapshot);
    User user = User.fromJson(userJson).copyWith(id: userJson['id']);
    return user;
  }

  Future<String> findUserByEmail(String email) async {
    DataSnapshot snapshot = await usersIdsRef.child(email).get();

    if (snapshot.exists && snapshot.value != null) {
      String userId = snapshot.value.toString();
      return userId;
    } else {
      return 'null';
    }
  }

  Future<void> updateUser(User user) async {
    Map<String, dynamic> updatedData = {
      'email': user.email,
      'phone_number': user.phoneNumber,
      'phone_ids': user.phones,
      'username': user.username,
    };
    await usersRef.child(user.id!).update(updatedData);
  }

  Future<void> updateUserName(String username, String userId) async {
    Map<String, dynamic> updatedData = {
      'username': username,
    };
    await usersRef.child(userId).update(updatedData);
  }

  Future<void> updateUserProfile(
      String userId, String avatarId, String profileType) async {
    Map<String, dynamic> updatedData = {
      'profile': {
        'avatar': avatarId,
        'type': profileType,
      },
    };
    await usersRef.child(userId).update(updatedData);
  }

  static Map<String, dynamic> decodeJsonFromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists) {
      Map<dynamic, dynamic> dataFromSnapshot =
          snapshot.value as Map<dynamic, dynamic>;
      final jsonToReturn = <String, dynamic>{};

      dataFromSnapshot.forEach((key, value) {
        if (key is String) {
          if (value is Map) {
            jsonToReturn[key] = Map<String, dynamic>.from(value);
          } else {
            jsonToReturn[key] = value;
          }
        }
      });

      if (jsonToReturn['phone_ids'] is String) {
        final phoneIdsString = jsonToReturn['phone_ids'] as String;
        jsonToReturn['phone_ids'] = json.decode(phoneIdsString);
      }

      jsonToReturn['id'] = snapshot.key;

      return jsonToReturn;
    } else {
      throw Exception('No data found for this snapshot');
    }
  }
}

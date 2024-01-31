import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/providers/map_providers.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference usersRef = database.ref('users');
DatabaseReference usersIdsRef = database.ref('userIds');
DatabaseReference locationsRef = database.ref('locations');

class DatabaseService {
  registerUser(User user, String id, String base64) async {
    final newUserRef = database.ref('users/$id');
    await newUserRef.set({
      'username': user.name,
      'email': user.email ?? 'null',
      'phone_ids': json.encode(user.phoneIds),
      'phone_number': user.phoneNumber ?? 'null'
    });
    final newUsersIdRef = database.ref('userIds/$base64');
    newUsersIdRef.set('$id');
  }

  Future<void> updateUser(User user) async {
    Map<String, dynamic> updatedData = {
      'email': user.email,
      'phone_number': user.phoneNumber,
      'phone_ids': user.phoneIds,
      'username': user.name,
    };
    await usersRef.child(user.userId!).update(updatedData);
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

  Future<User> getUserById(String userId) async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    DataSnapshot snapshot = await usersRef.child(userId).get();

    if (!snapshot.exists) {
      throw Exception('User not found');
    }

    return _userFromSnapshot(snapshot);
  }

  Future<void> getAllPlaces(WidgetRef ref) async {
    DatabaseReference Places = FirebaseDatabase.instance.ref('locations');
    DataSnapshot snapshot = await Places.get();
    List<Place> placesList = [];

    if (snapshot.exists) {
      Map<dynamic, dynamic> placesData =
          snapshot.value as Map<dynamic, dynamic>;
      placesData.forEach((key, value) {
        Place place = Place.fromSnapshot(value, key);
        placesList.add(place);
      });
    }
    ref.read(placesProvider.notifier).addPlaces(placesList);
  }
}

Future<User> _userFromSnapshot(DataSnapshot snapshot) async {
  Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;

  List<String> phoneIds;
  var phoneIdsData = userData['phone_ids'];
  if (phoneIdsData is String) {
    phoneIds = List<String>.from(json.decode(phoneIdsData));
  } else if (phoneIdsData is List) {
    phoneIds = List<String>.from(phoneIdsData);
  } else {
    phoneIds = [];
  }

  return User(
    userId: snapshot.key,
    email: userData['email'],
    phoneNumber: userData['phone_number'],
    phoneIds: phoneIds,
    name: userData['username'],
  );
}

//  await FirebaseFirestore.instance.collection('users').doc(id).set({
//         'username': _enteredUsername,
//         'email': _enteredEmail,
//         'phone_id': deviceInfo[0],
//         'device_type': deviceInfo[1],
//       });

//  ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Auth succes")));
//       ScaffoldMessenger.of(context).clearSnackBars();
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/repositories/database_repository.dart'; 


final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository();
});

Stream<List<String>> getUserEmailsByRewardLevel(int rewardLevel) async* {
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
  final DatabaseReference collectedPlacesRef = FirebaseDatabase.instance.ref('collectedLocationsByUsers');

  final usersStream = usersRef.onValue;

  await for (final userEvent in usersStream) {
    final collectedPlacesSnapshot = await collectedPlacesRef.get();
    final Map<dynamic, dynamic>? users = userEvent.snapshot.value as Map<dynamic, dynamic>?;
    final Map<dynamic, dynamic>? collectedPlacesData = collectedPlacesSnapshot.value as Map<dynamic, dynamic>?;

    if (users != null && collectedPlacesData != null) {
      List<String> emails = [];

      users.forEach((userId, userData) {
        if (userData['email'] != null && collectedPlacesData.containsKey(userId)) {
          final collectedPlaces = List.from(collectedPlacesData[userId]);
          final collectedPlacesCount = collectedPlaces.length;

          if (collectedPlacesCount >= rewardLevel) {
            emails.add(userData['email']);
          }
        }
      });

      yield emails;
    } else {
      yield [];
    }
  }
}

Future<List<String>> getUserEmailsByRewardLevelOnce(int rewardLevel) async {
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
  final DatabaseReference collectedPlacesRef = FirebaseDatabase.instance.ref('collectedLocationsByUsers');

  final usersSnapshot = await usersRef.get();
  final collectedPlacesSnapshot = await collectedPlacesRef.get();

  final Map<dynamic, dynamic>? users = usersSnapshot.value as Map<dynamic, dynamic>?;
  final Map<dynamic, dynamic>? collectedPlacesData = collectedPlacesSnapshot.value as Map<dynamic, dynamic>?;

  if (users != null && collectedPlacesData != null) {
    List<String> emails = [];

    users.forEach((userId, userData) {
      if (userData['email'] != null && collectedPlacesData.containsKey(userId)) {
        final collectedPlaces = List<dynamic>.from(collectedPlacesData[userId] ?? []);
        final collectedPlacesCount = collectedPlaces.length;

        if (collectedPlacesCount >= rewardLevel) {
          emails.add(userData['email']);
        }
      }
    });

    return emails;
  } else {
    return [];
  }
}
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

// Data model representing a user
class PersonsItem {
  PersonsItem({
    required this.personsName,
    required this.stampsNumber,
    required this.profileIcon,
  });

  final String personsName;
  final int stampsNumber;
  final String profileIcon;

  @override
  String toString() => '$personsName ($stampsNumber)';
}

// Define a Level model
class Level {
  Level({required this.name, required this.min, required this.max});
  final String name;
  final int min;
  final int max;
}

// 12 predefined levels
final List<Level> levels = [
  Level(name: 'Legendárny', min: 60, max: 1000),
  Level(name: 'Majster', min: 55, max: 59),
  Level(name: 'Šampión', min: 50, max: 54),
  Level(name: 'Expert', min: 45, max: 49),
  Level(name: 'Pokročilý', min: 40, max: 44),
  Level(name: 'Zdatný', min: 35, max: 39),
  Level(name: 'Skúsený', min: 30, max: 34),
  Level(name: 'Taktik', min: 25, max: 29),
  Level(name: 'Začiatočník', min: 20, max: 24),
  Level(name: 'Nováčik', min: 15, max: 19),
  Level(name: 'Začiatok', min: 10, max: 14),
  Level(name: 'Rookie', min: 5, max: 9),
];

// Repository for fetching data from Firebase
class UsersRepository {
  final _db = FirebaseDatabase.instance;

  Future<Map<String, String>> getUsernames() async {
    log('Fetching usernames...');
    final usersRef = _db.ref('users');
    final snapshot = await usersRef.get();
    if (!snapshot.exists) {
      log('No users found in DB.');
      return {};
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final mapped = data.map((userId, userData) {
      final username = (userData as Map)['username'] as String? ?? 'Unknown';
      return MapEntry(userId, username);
    });
    log('Usernames fetched: $mapped');
    return mapped;
  }

  Future<Map<String, int>> getCollectedLocationCounts() async {
    log('Fetching collected location counts...');
    final ref = _db.ref('collectedLocationsByUsers');
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      log('No collectedLocationsByUsers found in DB.');
      return {};
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final mapped = data.map((userId, locations) {
      final list = (locations as List?) ?? [];
      return MapEntry(userId, list.length);
    });
    log('Location counts fetched: $mapped');
    return mapped;
  }

  Future<List<PersonsItem>> fetchFullUserList() async {
    log('Fetching full user list...');
    final usernames = await getUsernames();
    final stampsByUserID = await getCollectedLocationCounts();

    final users = stampsByUserID.entries.map((entry) {
      final userId = entry.key;
      final stampCount = entry.value;
      final username = usernames[userId] ?? 'Unknown User';

      return PersonsItem(
        personsName: username,
        stampsNumber: stampCount,
        profileIcon: 'assets/avatars/kasko.png',
      );
    }).toList();

    users.sort((a, b) => b.stampsNumber.compareTo(a.stampsNumber));
    log('Final sorted user list: $users');
    return users;
  }
}

// A StateNotifier that holds and manages the state of the user list
class UsersNotifier extends StateNotifier<AsyncValue<List<PersonsItem>>> {
  UsersNotifier(this._repo) : super(const AsyncValue.loading()) {
    _loadUsers();
  }

  final UsersRepository _repo;

  Future<void> _loadUsers() async {
    log('UsersNotifier: _loadUsers called');
    try {
      final users = await _repo.fetchFullUserList();
      log('UsersNotifier: Data loaded successfully, got ${users.length} users.');
      state = AsyncValue.data(users);
    } catch (e, st) {
      log('UsersNotifier: Error loading data: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    log('UsersNotifier: refresh called');
    state = const AsyncValue.loading();
    await _loadUsers();
  }

  // Filter users by a given level index (1 to 12)
  List<PersonsItem> getUsersForLevel(int levelIndex) {
    if (levelIndex < 1 || levelIndex > levels.length) {
      throw ArgumentError(
          'Invalid level index: $levelIndex. Must be between 1 and ${levels.length}.');
    }

    final currentState = state.asData?.value;
    if (currentState == null) {
      // If data isn't loaded yet, return empty
      return [];
    }

    final level = levels[levelIndex - 1];
    return currentState.where((user) {
      return user.stampsNumber >= level.min && user.stampsNumber <= level.max;
    }).toList();
  }
}

// Provide the UsersRepository so it can be read by Notifier
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  log('usersRepositoryProvider created');
  return UsersRepository();
});

// Provide the UsersNotifier instance and let Riverpod manage its lifecycle
final usersNotifierProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<PersonsItem>>>((ref) {
  log('usersNotifierProvider initialized');
  final repo = ref.watch(usersRepositoryProvider);
  return UsersNotifier(repo);
});

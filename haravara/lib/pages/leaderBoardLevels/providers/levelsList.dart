import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class LevelsData {
  LevelsData({required this.users, required this.levels});
  final List<PersonsItem> users;
  final List<Level> levels;
}

class Level {
  Level({
    required this.name,
    required this.min,
    required this.max,
    required this.levelColor,
    this.profileIcons,
    this.isOpened,
    this.amountOfPeople,
  });

  final String name;
  final int min;
  final int max;
  final int levelColor;
  List<String>? profileIcons;
  bool? isOpened;
  int? amountOfPeople;

  Level copyWith({
    List<String>? profileIcons,
    bool? isOpened,
    int? amountOfPeople,
  }) {
    return Level(
      name: name,
      min: min,
      max: max,
      levelColor: levelColor,
      profileIcons: profileIcons ?? this.profileIcons,
      isOpened: isOpened ?? this.isOpened,
      amountOfPeople: amountOfPeople ?? this.amountOfPeople,
    );
  }
}

final List<Level> levels = [
  Level(
      name: 'Dúhový \njednorožec', min: 60, max: 1000, levelColor: 0xFF4A148C),
  Level(name: 'Pyšný \npáv', min: 55, max: 59, levelColor: 0xFF8E24AA),
  Level(name: 'Tajomný \npanter', min: 50, max: 54, levelColor: 0xFFD81B60),
  Level(name: 'Šikovná \nveverička', min: 45, max: 49, levelColor: 0xFFE65100),
  Level(name: 'Splašená \nčivava', min: 40, max: 44, levelColor: 0xFFFF6F00),
  Level(name: 'Zvedavá \nsurikata', min: 35, max: 39, levelColor: 0xFFF57C00),
  Level(name: 'Vyhúkaná \nsova', min: 30, max: 34, levelColor: 0xFFFFB300),
  Level(name: 'Vytrvalý \nbobor', min: 25, max: 29, levelColor: 0xFFFFD600),
  Level(
      name: 'Popletená \nchobotnička',
      min: 20,
      max: 24,
      levelColor: 0xFF76FF03),
  Level(name: 'Turbo \nleňochod', min: 15, max: 19, levelColor: 0xFF00E676),
  Level(name: 'Vytrvalý \nslimáčik', min: 10, max: 14, levelColor: 0xFF1DE9B6),
  Level(name: 'Ospalý \npavúčik', min: 5, max: 9, levelColor: 0xFF00B0FF),
];

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
    return data.map((userId, userData) {
      final username = (userData as Map)['username'] as String? ?? 'Unknown';
      return MapEntry(userId, username);
    });
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
    return data.map((userId, locations) {
      final list = (locations as List?) ?? [];
      return MapEntry(userId, list.length);
    });
  }

  Future<Map<String, String>> getAvatars() async {
    log('Fetching avatars...');
    final avatarsRef = _db.ref('avatars');
    final snapshot = await avatarsRef.get();
    if (!snapshot.exists) {
      log('No avatars found in DB.');
      return {};
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.map((avatarId, avatarData) {
      final location = (avatarData as Map)['location'] as String? ?? '';
      return MapEntry(avatarId, location);
    });
  }

  Future<LevelsData> fetchLevelsData() async {
    log('Fetching data...');
    final usernames = await getUsernames();
    final stampsByUserID = await getCollectedLocationCounts();
    final avatars = await getAvatars();

    // Get current user's ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString('id');
    if (currentUserId == null) {
      throw Exception('Current user ID not found in SharedPreferences.');
    }

    // Get current user's collected location count
    final currentUserStamps = stampsByUserID[currentUserId] ?? 0;
    log('Current user stamps: $currentUserStamps');

    // Build the full users list
    final users = stampsByUserID.entries.map((entry) {
      final userId = entry.key;
      final stampCount = entry.value;
      final username = usernames[userId] ?? 'Unknown User';

      // Fetch avatar from 'users' table
      final userAvatarId =
          _db.ref('users/$userId/profile/avatar').get().then((snapshot) {
        return snapshot.value as String? ?? '';
      });

      return PersonsItem(
        personsName: username,
        stampsNumber: stampCount,
        profileIcon: avatars[userAvatarId] ?? 'assets/avatars/kasko.png',
      );
    }).toList();

    users.sort((a, b) => b.stampsNumber.compareTo(a.stampsNumber));
    log('Final sorted user list: $users');

    // Update levels based on users
    final updatedLevels = levels.map((lvl) {
      final levelUsers = users.where((user) {
        return user.stampsNumber >= lvl.min && user.stampsNumber <= lvl.max;
      }).toList();

      final topIcons = levelUsers
          .take(3)
          .map((user) => user.profileIcon)
          .toList(); // Top 3 profile icons

      // Check if the current user has enough stamps to open this level
      final isOpenedVar = currentUserStamps >= lvl.min;

      return lvl.copyWith(
        amountOfPeople: levelUsers.length,
        isOpened: isOpenedVar,
        profileIcons: topIcons,
      );
    }).toList();

    return LevelsData(users: users, levels: updatedLevels);
  }
}

// A StateNotifier that holds and manages the state of the LevelsData (users + updated levels)
class UsersNotifier extends StateNotifier<AsyncValue<LevelsData>> {
  UsersNotifier(this._repo) : super(const AsyncValue.loading()) {
    _loadData();
  }

  final UsersRepository _repo;

  Future<void> _loadData() async {
    log('UsersNotifier: _loadData called');
    try {
      final data = await _repo.fetchLevelsData();
      log('UsersNotifier: Data loaded successfully, got ${data.users.length} users.');
      state = AsyncValue.data(data);
    } catch (e, st) {
      log('UsersNotifier: Error loading data: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    log('UsersNotifier: refresh called');
    state = const AsyncValue.loading();
    await _loadData();
  }
}

// Provide the UsersRepository so it can be read by Notifier
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  log('usersRepositoryProvider created');
  return UsersRepository();
});

// Provide the UsersNotifier instance and let Riverpod manage its lifecycle
final usersNotifierProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<LevelsData>>((ref) {
  log('usersNotifierProvider initialized');
  final repo = ref.watch(usersRepositoryProvider);
  return UsersNotifier(repo);
});

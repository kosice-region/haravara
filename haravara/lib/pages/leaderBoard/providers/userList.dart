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

class Level {
  Level({
    required this.name,
    required this.min,
    required this.max,
    required this.levelColor,
    required this.badgeImage,
    this.profileIcons,
    this.isOpened,
    this.amountOfPeople,
  });

  final String name;
  final int min;
  final int max;
  final int levelColor;
  final String badgeImage;
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
      badgeImage: badgeImage,
      profileIcons: profileIcons ?? this.profileIcons,
      isOpened: isOpened ?? this.isOpened,
      amountOfPeople: amountOfPeople ?? this.amountOfPeople,
    );
  }
}

final List<Level> levels = [
  Level(
    name: 'Dúhový \njednorožec',
    min: 60,
    max: 1000,
    levelColor: 0xFF4A148C,
    badgeImage: 'assets/badges/60_jednorozec.png',
  ),
  Level(
    name: 'Pyšný \npáv',
    min: 55,
    max: 59,
    levelColor: 0xFF8E24AA,
    badgeImage: 'assets/badges/55_pav.png',
  ),
  Level(
    name: 'Tajomný \npanter',
    min: 50,
    max: 54,
    levelColor: 0xFFD81B60,
    badgeImage: 'assets/badges/50_panter.png',
  ),
  Level(
    name: 'Šikovná \nveverička',
    min: 45,
    max: 49,
    levelColor: 0xFFE65100,
    badgeImage: 'assets/badges/45_vevericka.png',
  ),
  Level(
    name: 'Splašená \nčivava',
    min: 40,
    max: 44,
    levelColor: 0xFFFF6F00,
    badgeImage: 'assets/badges/40_civava.png',
  ),
  Level(
    name: 'Zvedavá \nsurikata',
    min: 35,
    max: 39,
    levelColor: 0xFFF57C00,
    badgeImage: 'assets/badges/35_surikata.png',
  ),
  Level(
    name: 'Vyhúkaná \nsova',
    min: 30,
    max: 34,
    levelColor: 0xFFFFB300,
    badgeImage: 'assets/badges/30_sova.png',
  ),
  Level(
    name: 'Vytrvalý \nbobor',
    min: 25,
    max: 29,
    levelColor: 0xFFFFD600,
    badgeImage: 'assets/badges/25_bobor.png',
  ),
  Level(
    name: 'Popletená \nchobotnička',
    min: 20,
    max: 24,
    levelColor: 0xFF76FF03,
    badgeImage: 'assets/badges/20_chobotnica.png',
  ),
  Level(
    name: 'Turbo \nleňochod',
    min: 15,
    max: 19,
    levelColor: 0xFF00E676,
    badgeImage: 'assets/badges/15_lenochod.png',
  ),
  Level(
    name: 'Vytrvalý \nslimáčik',
    min: 10,
    max: 14,
    levelColor: 0xFF1DE9B6,
    badgeImage: 'assets/badges/10_slimak.png',
  ),
  Level(
    name: 'Ospalý \npavúčik',
    min: 5,
    max: 9,
    levelColor: 0xFF00B0FF,
    badgeImage: 'assets/badges/05_pavuk.png',
  ),
];

// Repository for fetching data from Firebase
class UsersRepository {
  final Map<String, String> usersAvatars;
  UsersRepository({required this.usersAvatars});
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

    final futures = stampsByUserID.entries.map((entry) async {
      final userId = entry.key;
      final stampCount = entry.value;
      final username = usernames[userId] ?? 'Unknown User';
      final snapshot = await _db.ref('users/$userId/profile/avatar').get();
      final userAvatarId = snapshot.value as String? ?? '';

      return PersonsItem(
        personsName: username,
        stampsNumber: stampCount,
        profileIcon: usersAvatars[userAvatarId] ?? 'assets/avatars/kasko.png',
      );
    }).toList();
    // Use Future.wait to resolve the list of futures
    final users = await Future.wait(futures);

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

final usersRepositoryProvider =
    Provider.family<UsersRepository, Map<String, String>>((ref, usersAvatars) {
  log('usersRepositoryProvider created with avatars');
  return UsersRepository(usersAvatars: usersAvatars);
});

// Provider for UsersNotifier with dynamic usersAvatars dependency
final usersNotifierProvider = StateNotifierProvider.family<UsersNotifier,
    AsyncValue<List<PersonsItem>>, Map<String, String>>(
  (ref, usersAvatars) {
    final repository = UsersRepository(usersAvatars: usersAvatars);
    return UsersNotifier(repository);
  },
);

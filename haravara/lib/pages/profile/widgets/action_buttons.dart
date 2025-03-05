import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/repositories/database_repository.dart';

import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';


import '../../../core/widgets/Popup.dart';

import 'widgets.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/leaderBoard/providers/userList.dart';

DatabaseRepository DBrep = DatabaseRepository();

class ActionButtons extends ConsumerStatefulWidget {
  const ActionButtons({super.key});

  @override
  ConsumerState<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<ActionButtons> {
  late String username;
  late String newUsername = '';
  late String userId;
  String selectedCity = '';

  Future<bool> _updateUsername() async {
    if (newUsername.isEmpty || newUsername == "") {
      return true;
    }
    if (newUsername.length < 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(title:'Error',content: 'Meno musí obsahovať aspoň 3 znaky',);
        },
      );
      return false;
    }
    if (await DBrep.isUserNameUsed(newUsername)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(title:'Error',content: 'Toto meno už niekto používa',);
        },
      );
      return false;
    } else {
      await authRepository.updateUserName(newUsername, userId);
      await ref.read(userInfoProvider.notifier).updateUsername(newUsername);

      ref.invalidate(usersNotifierProvider);

      return true;
    }
  }

  _updateUserLocation() async {
    if (selectedCity.isEmpty) {
      return;
    }
    final avatar = ref.read(avatarsProvider.notifier).getCurrentAvatar();
    String userProfileType =
        ref.watch(userInfoProvider).isFamily ? 'family' : 'individual';
    int children = ref.watch(userInfoProvider).children;
    await authRepository.updateUserProfile(
        userId, avatar.id!, userProfileType, selectedCity, children);
    await ref.read(userInfoProvider.notifier).updateLocation(selectedCity);
  }

  @override
  void initState() {
    super.initState();
  }

  /// Determines the correct badge image based on the user's stamp count
  String getBadgeImageForUser(int stamps) {
    for (final level in levels) {
      if (stamps >= level.min && stamps <= level.max) {
        return level.badgeImage;
      }
    }
    return 'assets/badges/empty.png';
  }

  @override
  Widget build(BuildContext context) {
    username = ref.watch(userInfoProvider).username;
    userId = ref.watch(userInfoProvider).id;

    // Get user data from UsersNotifier
    final usersAvatars =
        ref.watch(avatarsProvider).getAllUserIdsAndAvatarLocations();
    final usersAsync = ref.watch(usersNotifierProvider(usersAvatars));

    final String currentUsername = ref.watch(userInfoProvider).username;

    final PersonsItem? currentUser = usersAsync.when(
      data: (users) => users.firstWhere(
        (user) => user.personsName == currentUsername,
        orElse: () =>
            PersonsItem(personsName: '', stampsNumber: 0, profileIcon: ''),
      ),
      loading: () => null,
      error: (_, __) => null,
    );
    final int userStamps = currentUser?.stampsNumber ?? 0;
    // final int userStamps = 30; //Uncomment it if you test each variant
    final String badgeImage = getBadgeImageForUser(userStamps);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.white, width: 4),
              backgroundColor: const Color.fromARGB(216, 81, 182, 240),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
              ),
            ),
            onPressed: () => _showUsernameDialog(context),
            child: Column(
              children: [
                SizedBox(height: 5.h),
                UsernameWidget(),
                Text(
                  ref.watch(placesProvider.select((state) =>
                      ref.read(placesProvider.notifier).getLevelOfSearcher())),
                  style: GoogleFonts.titanOne(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),

          // Positioned Badge Image
          Positioned(
            top: -25.h,
            right: -10.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: userStamps >= 5
                    ? [BoxShadow(color: Colors.white, blurRadius: 30)]
                    : [],
              ),
              child: Image.asset(
                badgeImage,
                width: 50.w,
                height: 50.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUsernameDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              'Upraviť údaje',
              style: GoogleFonts.titanOne(),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  child: TextField(
                    autofocus: true,
                    maxLength: 20,
                    onChanged: (value) {
                      setState(() {
                        newUsername = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Nové meno',
                      hintStyle: GoogleFonts.titanOne(
                        color: Color.fromARGB(255, 188, 95, 190),
                        fontWeight: FontWeight.w300,
                        fontSize: 11.sp,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 188, 95, 190),
                          width: 3.w,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 188, 95, 190),
                          width: 3.w,
                        ),
                      ),
                    ),
                    style: GoogleFonts.titanOne(
                      color: Color.fromARGB(255, 188, 95, 190),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                LocationField(
                  onLocationSelected: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Zrušiť',
                  style: GoogleFonts.titanOne(
                    color: Color.fromARGB(255, 188, 95, 190),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await _updateUsername()) {
                    _updateUserLocation();
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Uložiť',
                  style: GoogleFonts.titanOne(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 188, 95, 190),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

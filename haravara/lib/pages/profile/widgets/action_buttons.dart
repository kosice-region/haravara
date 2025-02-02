import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/providers/login_provider.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';

import '../../auth/services/auth_screen_service.dart';
import 'widgets.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/leaderBoard/providers/userList.dart'; // Adjust based on actual file location

class ActionButtons extends ConsumerStatefulWidget {
  const ActionButtons({super.key});

  @override
  ConsumerState<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<ActionButtons> {
  late String username;
  late String newUsername;
  late String userId;
  String selectedCity = '';

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
    return 'assets/badges/empty.png'; // Default fallback badge
  }

  @override
  Widget build(BuildContext context) {
    username = ref.watch(userInfoProvider).username;
    userId = ref.watch(userInfoProvider).id;

    // Get user data from UsersNotifier
    final usersAvatars =
        ref.watch(avatarsProvider).getAllUserIdsAndAvatarLocations();
    final usersAsync = ref.watch(usersNotifierProvider(usersAvatars));

    // Find current user based on ID
    final PersonsItem? currentUser = usersAsync.when(
      data: (users) => users.firstWhere(
        (user) => user.personsName == username,
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
            right: -5.w,
            bottom: 35.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [BoxShadow(color: Colors.white, blurRadius: 30)],
              ),
              child: Image.asset(
                badgeImage, // Correct badge image based on user's stamps
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
                  Navigator.of(context).pop();
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

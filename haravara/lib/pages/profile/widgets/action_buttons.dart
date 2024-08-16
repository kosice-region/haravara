import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/providers/login_provider.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/map_detail/providers/collected_places_provider.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';

import 'widgets.dart';

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

  _updateUsername() async {
    if (newUsername.isEmpty) {
      return;
    }
    await authRepository.updateUserName(newUsername, userId);
    await ref.read(userInfoProvider.notifier).updateUsername(newUsername);
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

  @override
  Widget build(BuildContext context) {
    username = ref.watch(userInfoProvider).username;
    userId = ref.watch(userInfoProvider).id;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
        width: 91.w,
        height: 30.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 255, 111, 122),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
          ),
          onPressed: () async {
            handleLogout(ref, context);
          },
          child: Text(
            'ODHLÁSIŤ',
            style: GoogleFonts.titanOne(
              color: Colors.black,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
      Container(
        width: 91.w,
        height: 30.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(229, 158, 230, 165),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
          ),
          onPressed: () => _showUsernameDialog(context),
          child: Text(
            'UPRAVIŤ',
            style: GoogleFonts.titanOne(color: Colors.black, fontSize: 12.sp),
          ),
        ),
      ),
    ]);
  }

  void _showUsernameDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Upraviť udaje',
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
                onPressed: () {
                  _updateUsername();
                  _updateUserLocation();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Uložiť',
                  style: GoogleFonts.titanOne(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 188, 95, 190), // Button color
                ),
              ),
            ],
          );
        });
  }

  Future<void> handleLogout(WidgetRef ref, BuildContext context) async {
    ref.read(loginNotifierProvider.notifier).logout();
    ref.read(collectedPlacesProvider.notifier).deleteAllPlaces();
    await ref.read(userInfoProvider.notifier).clear();
    ref.invalidate(loginNotifierProvider);
    ref.invalidate(userInfoProvider);
    await DatabaseService().clearRichedPlaces();
    await DatabaseService().clearUserAllAvatarsFromDatabase();
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.auth));
  }
}

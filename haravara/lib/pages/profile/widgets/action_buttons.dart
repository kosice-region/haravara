import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/providers/login_provider.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/map_detail/providers/collected_places_provider.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/core/repositories/database_repository.dart';

import '../../auth/services/auth_screen_service.dart';
import 'widgets.dart';

DatabaseRepository DBrep = DatabaseRepository();

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

  Future<bool> _updateUsername() async {
    if (newUsername.isEmpty || newUsername == "") {
      return true;
    }
    if (await DBrep.isUserNameUsed(newUsername)) {
      showSnackBar(context, 'Toto meno už niekto použiva');
      return false;
    } else {
      await authRepository.updateUserName(newUsername, userId);
      await ref.read(userInfoProvider.notifier).updateUsername(newUsername);
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

  @override
  Widget build(BuildContext context) {
    username = ref.watch(userInfoProvider).username;
    userId = ref.watch(userInfoProvider).id;
    final Color color = Colors.white;

    String levelOfSearcher = ref.watch(placesProvider.select(
        (state) => ref.read(placesProvider.notifier).getLevelOfSearcher()));

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: Colors.white, width: 4),
            backgroundColor: const Color.fromARGB(216, 81, 182, 240),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            ),
          ),
          onPressed: () => _showUsernameDialog(context),
          child: Column(children: [
            SizedBox(height: 5.h),
            UsernameWidget(),
            Text(levelOfSearcher,
                style: GoogleFonts.titanOne(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w300,
                  color: color,
                )),
            SizedBox(height: 10.h),
          ]),
        ));
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

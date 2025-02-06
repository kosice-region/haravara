import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/core/providers/login_provider.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/admin/view/screens/admin_actual_rewards_screen.dart';
import 'package:haravara/pages/admin/view/screens/special_rewards/special_reward_screen.dart';
import 'package:haravara/pages/map_detail/providers/collected_places_provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/pages/admin/view/screens/admin_assign_stamps_screen.dart';

class AdminMenu extends ConsumerStatefulWidget {
  const AdminMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminMenu> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends ConsumerState<AdminMenu> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenUtil.init(context, designSize: const Size(255, 516));
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/backgrounds/verification_background.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h),
            child: const Header(),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminActualRewardsScreen(), 
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150.w, 40.h),
                    backgroundColor: const Color(0xFF9260A8),
                    side: const BorderSide(color: Colors.white, width: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Ceny',
                    style: GoogleFonts.titanOne(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpecialRewardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150.w, 40.h),
                    backgroundColor: const Color(0xFFE65F33),
                    side: const BorderSide(color: Colors.white, width: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Špecialne ceny',
                    style: GoogleFonts.titanOne(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminAssignStampsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150.w, 40.h),
                    backgroundColor: const Color(0xFF33C233),
                    side: const BorderSide(color: Colors.white, width: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Pridaj pečiatky',
                    style: GoogleFonts.titanOne(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
                buildAdminButton(context, 'Odhlásiť', Colors.red,
                    isLogout: true),
              ],
            ),
          ),
          Positioned(
            top: 67.h,
            right: 30.w,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  'assets/menu-icons/backbutton.png',
                  width: 36.w,
                  height: 36.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAdminButton(BuildContext context, String buttonText, Color color,
      {bool isLogout = false}) {
    return ElevatedButton(
      onPressed: () async {
        if (isLogout) {
          await handleLogout(ref, context);
        } else {
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(150.w, 40.h),
        backgroundColor: color,
        side: const BorderSide(color: Colors.white, width: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.titanOne(
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> handleLogout(WidgetRef ref, BuildContext context) async {
    await FirebaseAuth.instance.signOut();
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

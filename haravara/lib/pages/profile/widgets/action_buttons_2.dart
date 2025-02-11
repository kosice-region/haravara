import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../router/router.dart';
import '../../../router/screen_router.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:haravara/core/providers/login_provider.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/map_detail/providers/collected_places_provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';

class ActionButtons2 extends ConsumerStatefulWidget {
  const ActionButtons2({super.key});

  @override
  ConsumerState<ActionButtons2> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<ActionButtons2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 105.w,
          height: 40.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 190, 0),
              foregroundColor: Colors.black,
              side: BorderSide(
                color: Colors.white,
                width: 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            onPressed: () {

              ref.read(routerProvider.notifier).changeScreen(ScreenType.bugreport);
              ScreenRouter().routeToNextScreen(

                context,
                ScreenRouter().getScreenWidget(ScreenType.bugreport),
              );
            },
            child: Text(
              'Nahlásiť\nproblem',
              style: GoogleFonts.titanOne(
                color: Colors.white,
                fontSize: 11.sp,
              ),
            ),
          ),
        ),
        Container(
          width: 105.w,
          height: 40.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFD584A),
              foregroundColor: Colors.black,
              side: BorderSide(
                color: Colors.white,
                width: 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            onPressed: () async {
              handleLogout(ref, context);
            },
            child: Text(
              'Odhlásiť',
              style: GoogleFonts.titanOne(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ],
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

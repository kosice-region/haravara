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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                  await handleLogout(ref, context);
                },
                child: Text(
                  'Odhlásiť',
                  style: GoogleFonts.titanOne(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          width: 220.w,
          height: 40.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 228, 28, 10),
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
              await confirmAccountDeletion(context, ref);
            },
            child: Text(
              'Vymazať účet',
              style: GoogleFonts.titanOne(
                color: Colors.white,
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
      context,
      ScreenRouter().getScreenWidget(ScreenType.auth),
    );
  }

  Future<void> confirmAccountDeletion(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Potvrdenie'),
        content: Text('Naozaj chcete vymazať svoj účet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Nie'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Áno'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    String input = '';
    final textController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Zadajte potvrdenie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pre vymazanie účtu napíšte: "vymazat ucet" bez diakritiky a úvodzoviek.'),
            TextField(
              controller: textController,
              onChanged: (val) => input = val,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Zrušiť'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().toLowerCase() == 'vymazat ucet') {
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Zle zadané potvrdenie')),
                );
              }
            },
            child: Text('Potvrdiť'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Simulate backend call
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context); // close loading

    // Call logout and cleanup
    // await handleLogout(ref, context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Účet bol úspešne vymazaný')),
    );
  }
}

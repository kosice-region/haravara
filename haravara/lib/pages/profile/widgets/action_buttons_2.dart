import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../router/router.dart';
import '../../../router/screen_router.dart';

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
          width: 135.w,
          height: 30.h,
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
              ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
                context,
                ScreenRouter().getScreenWidget(ScreenType.bugreport),
              );
            },
            child: Text(
              'Nahlásiť problém',
              style: GoogleFonts.titanOne(
                color: Colors.white,
                fontSize: 11.sp,
              ),
            ),
          ),
        ),
        Container(
          width: 91.w,
          height: 30.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white,
                width: 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              elevation: 3,
              shadowColor: Colors.white.withOpacity(0.3),
            ),
            onPressed: () => null,
            child: Text(
              'Info',
              style: GoogleFonts.titanOne(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

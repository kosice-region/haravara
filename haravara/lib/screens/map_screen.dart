import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/screens/map_detail_screen.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:haravara/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:page_transition/page_transition.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    final places = ref.watch(placesProvider);
    return Scaffold(
      endDrawer: const HeaderMenu(),
      body: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          children: [
            const Header(),
            30.verticalSpace,
            Center(
              child: Text(
                'MAPA PEČIATOK',
                style: GoogleFonts.titanOne(
                  fontSize: 17.sp,
                  color: const Color.fromARGB(255, 1, 199, 67),
                ),
              ),
            ),
            10.verticalSpace,
            Container(
                height: 110.h,
                width: 225.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  child: Container(),
                )),
            14.verticalSpace,
            if (Platform.isIOS)
              Column(
                children: [
                  CupertinoButton(
                    onPressed: () {
                      navigateToMap();
                    },
                    color: places.isNotEmpty
                        ? const Color.fromARGB(255, 7, 179, 25)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    child: Text(
                      'Otvoriť mapu',
                      style: GoogleFonts.titanOne(color: Colors.white),
                    ),
                  ),
                ],
              ),
            if (Platform.isAndroid)
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: places.isNotEmpty
                          ? const Color.fromARGB(255, 7, 179, 25)
                          : Colors.grey,
                    ),
                    onPressed: () {
                      navigateToMap();
                    },
                    child: Text(
                      'Otvoriť mapu',
                      style: GoogleFonts.titanOne(color: Colors.white),
                    ),
                  ),
                  10.verticalSpace,
                ],
              ),
            Image.asset(
              'assets/peopleMapScreen.png',
            ),
          ],
        ),
      ),
      bottomSheet: const Footer(height: 175, boxFit: BoxFit.fill),
    );
  }

  navigateToMap() {
    if (Platform.isAndroid) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          duration: const Duration(seconds: 1),
          child: const MapDetailScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const MapDetailScreen(),
        ),
      );
    }
  }
}

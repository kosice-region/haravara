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

  final List<String> imageAssets = [
    'assets/places-map.jpg',
    'assets/peopleMapScreen.png',
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    ScreenUtil.init(context, designSize: const Size(255, 516));
    final places = ref.watch(placesProvider);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 232, 209),
      endDrawer: HeaderMenu(),
      body: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          children: [
            const Header(),
            10.verticalSpace,
            Center(
              child: Text(
                'MAPA PEČIATOK',
                style: GoogleFonts.titanOne(
                  fontSize: 17.sp,
                  color: const Color.fromARGB(255, 86, 162, 73),
                ),
              ),
            ),
            // 10.verticalSpace,
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                navigateToMap();
              },
              child: Container(
                width: 302.w,
                height: 150.h,
                child: Image.asset(
                  'assets/places-map.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

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
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: places.isNotEmpty
                  //         ? const Color.fromARGB(255, 7, 179, 25)
                  //         : Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     navigateToMap();
                  //   },
                  //   child: Text(
                  //     'Otvoriť mapu',
                  //     style: GoogleFonts.titanOne(color: Colors.white),
                  //   ),
                  // ),
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

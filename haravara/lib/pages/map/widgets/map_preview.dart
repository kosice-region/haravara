import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/map_detail/view/map_detail_screen.dart';
import 'package:page_transition/page_transition.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
      ),
      onPressed: () {
        navigateToMap(context);
      },
      child: Container(
        width: 302.w,
        height: 150.h,
        child: Image.asset(
          'assets/places-map-preview.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  navigateToMap(context) {
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

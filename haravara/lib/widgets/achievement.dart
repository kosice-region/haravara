import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/place.dart';

enum ScreenSize {
  two,
  three,
}

class Achievement extends StatelessWidget {
  const Achievement({
    super.key,
    this.size = ScreenSize.two,
    required this.place,
  });

  final Place place;
  final ScreenSize size;
  @override
  Widget build(BuildContext context) {
    int fontSizeMax = 12;
    int fontSizeMin = 7;
    var deviceHeight = MediaQuery.of(context).size.height;
    if (deviceHeight < 700) {
      fontSizeMax = 10;
      fontSizeMin = 8;
    }
    final isSizeTwo = (size == ScreenSize.two);
    final isClosed = !place.isReached;
    return Column(
      children: [
        if (isClosed)
          Container(
            width: isSizeTwo ? 99.w : 70.w,
            height: isSizeTwo ? 100.h : 80.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(26)).r,
              color: const Color.fromARGB(255, 91, 187, 75),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.7,
                child: Image.asset('assets/Icon.jpeg', fit: BoxFit.fill),
              ),
            ),
          ),
        if (!isClosed)
          SizedBox(
            width: isSizeTwo ? 140.w : 120.w,
            height: isSizeTwo ? 100.h : 80.h,
            child: Image.file(
              File(place.placeImages!.stamp),
              fit: BoxFit.contain,
            ),
          ),
        5.verticalSpace,
        Container(
          width: isSizeTwo ? 109.w : 80.w,
          height: isSizeTwo ? 36.h : 30.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: const Color.fromARGB(255, 155, 221, 153)),
          child: Center(
            child: Text(
              place.name,
              style: GoogleFonts.titanOne(
                  color: Colors.black,
                  fontSize: isSizeTwo ? fontSizeMax.sp : fontSizeMin.sp),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

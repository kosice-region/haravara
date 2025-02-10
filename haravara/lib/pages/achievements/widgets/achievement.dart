import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/models/place.dart';

enum ScreenSize {
  two,
  three,
}

class Achievement extends ConsumerStatefulWidget {
  const Achievement({
    super.key,
    this.size = ScreenSize.two,
    required this.place,
  });

  final Place place;
  final ScreenSize size;

  @override
  ConsumerState<Achievement> createState() => _AchievementState();
}

class _AchievementState extends ConsumerState<Achievement> {
  @override
  Widget build(BuildContext context) {
    int fontSizeMax = 9;
    int fontSizeMin = 7;
    var deviceHeight = MediaQuery.of(context).size.height;
    if (deviceHeight < 700) {
      fontSizeMax = 10;
      fontSizeMin = 8;
    }
    final isSizeTwo = (widget.size == ScreenSize.two);
    final isClosed = !widget.place.isReached;

    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            if (isClosed)
              Container(
                width: isSizeTwo ? 100.w : 70.w,
                height: isSizeTwo ? 100.h : 70.h,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)).r,
                  color: const Color(0xFF67B5E1),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 4.0,
                  ),
                ),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 0.7,
                    child: Image.asset('assets/PECIATKA.png', fit: BoxFit.fill),
                  ),
                ),
              ),
            if (!isClosed)
              SizedBox(
                width: isSizeTwo ? 140.w : 80.w,
                height: isSizeTwo ? 100.h : 70.h,
                child: Image.file(
                  File(widget.place.placeImages!.stamp),
                  fit: BoxFit.contain,
                ),
              ),
            5.verticalSpace,
            Container(
              width: isSizeTwo ? 120.w : 80.w,
              height: isSizeTwo ? 40.h : 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: const Color(0xFF1666B1),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    widget.place.name,
                    style: GoogleFonts.titanOne(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: isSizeTwo ? fontSizeMax.sp : fontSizeMin.sp,
                    ),
                    maxLines: 5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

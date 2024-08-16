import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Distance extends StatelessWidget {
  const Distance({super.key, this.distanceToTarget});

  final distanceToTarget;

  getColorForDistance(double distance) {
    if (distance > 250) {
      return const Color.fromARGB(255, 70, 68, 205);
    }
    if (distance < 25) return Color.fromARGB(255, 233, 18, 18);
    if (distance < 100) return Color.fromARGB(255, 225, 222, 16);
    return Color.fromARGB(255, 215, 16, 246);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          20.horizontalSpace,
          Image.asset(
            'assets/mayka_shows.png',
            width: 90.w,
            height: 147.h,
          ),
          Container(
            width: 117.w,
            height: 43.h,
            decoration: BoxDecoration(
              color: getColorForDistance(this.distanceToTarget),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Center(
              child: Text(
                distanceToTarget > 1000
                    ? '${(distanceToTarget / 1000).toStringAsFixed(0)} KM'
                    : '${distanceToTarget.toStringAsFixed(0)} M',
                style:
                    GoogleFonts.titanOne(color: Colors.white, fontSize: 24.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

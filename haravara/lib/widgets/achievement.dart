import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Achievement extends StatelessWidget {
  const Achievement({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Column(
        children: [
          Container(
            width: 150.w,
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(52.r),
              color: const Color.fromARGB(255, 91, 187, 75),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Image.asset(
                'assets/Icon.jpeg',
                scale: 0.6,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: 160.w,
            height: 50.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: const Color.fromARGB(255, 155, 221, 153)),
            child: Center(
              child: Text(
                'Dom sv.Alzbety',
                style:
                    GoogleFonts.titanOne(color: Colors.black, fontSize: 15.sp),
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

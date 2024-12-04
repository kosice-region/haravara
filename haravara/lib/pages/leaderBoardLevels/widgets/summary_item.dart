import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 195.w,
            height: 62.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)).r,
              color: const Color.fromARGB(255, 177, 235, 183),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 91, 187, 75).withOpacity(1),
                  spreadRadius: 8,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          Positioned(
            top: -15.h,
            left: -20.w,
            child: Image.asset(
              'assets/budik.png',
              width: 60.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

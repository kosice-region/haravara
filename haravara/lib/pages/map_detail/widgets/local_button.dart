import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LocalButton extends StatelessWidget {
  final String name;
  final void Function()? onPressed;
  final bool isCompass;

  const LocalButton({
    super.key,
    required this.name,
    required this.onPressed,
    this.isCompass = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 27.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 7, 22, 121),
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onPressed,
        onLongPress: onPressed,
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.titanOne(color: Colors.white, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}

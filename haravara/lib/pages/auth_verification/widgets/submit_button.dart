import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 117.w,
      height: 25.h,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 231, 179, 51),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)).h,
            side: BorderSide(
              color: Color.fromARGB(255, 231, 179, 51),
              width: 2.0,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.titanOne(
            color: Colors.black,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

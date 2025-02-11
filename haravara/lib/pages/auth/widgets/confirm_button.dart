import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.titanOne(fontSize: 11.sp),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 239, 72, 77),
        side: const BorderSide(color: Colors.white, width: 3),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: 100.w,
        height: 20.h,
        child: Center(child: Text(text)),
      ),
    );
  }
}

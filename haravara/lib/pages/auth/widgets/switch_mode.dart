import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchMode extends StatefulWidget {
  const SwitchMode({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  State<SwitchMode> createState() => _SwitchModeState();
}

class _SwitchModeState extends State<SwitchMode> {
  @override
  Widget build(BuildContext context) {
    String formattedText = widget.text;
    if (widget.text.contains("ZAREGISTRUJ SA")) {
      formattedText =
          widget.text.replaceFirst("ZAREGISTRUJ SA", "\nZAREGISTRUJ SA");
    }
    return IntrinsicWidth(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.titanOne(fontSize: 9.sp),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 46, 204, 113),
          side: const BorderSide(color: Colors.white, width: 3),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        ),
        onPressed: widget.onPressed,
        child: Text(
          formattedText,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }
}

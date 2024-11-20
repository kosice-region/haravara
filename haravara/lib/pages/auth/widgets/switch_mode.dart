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
    String text = widget.text;
    return TextButton(
      child: Text(
        text,
        style: GoogleFonts.titanOne(
          fontSize: 10.sp,
          color: Color.fromARGB(255, 254, 152, 43),
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: widget.onPressed, 
    );
  }
}

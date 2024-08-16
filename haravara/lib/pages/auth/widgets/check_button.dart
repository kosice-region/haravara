import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckButton extends StatefulWidget {
  const CheckButton({
    Key? key,
    required this.value,
    required this.text,
    required this.onChanged,
  }) : super(key: key);
  final bool value;
  final String text;
  final ValueChanged<bool> onChanged;

  @override
  State<CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  @override
  Widget build(BuildContext context) {
    bool isFamily = widget.value;
    String text = widget.text;
    return SizedBox(
      width: 166.w,
      child: Row(
        children: [
          Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            activeColor: Color.fromARGB(255, 155, 221, 153),
            value: isFamily,
            onChanged: (value) {
              log('value $value');
              widget.onChanged(value!);
            },
          ),
          Text(
            text,
            style: GoogleFonts.titanOne(
              color: Color.fromARGB(255, 188, 95, 190),
              fontWeight: FontWeight.w300,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

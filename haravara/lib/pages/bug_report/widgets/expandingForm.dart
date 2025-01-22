import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FormRow extends StatelessWidget {
  const FormRow({
    Key? key,
    required this.title,
    required this.controller,
    required this.focusNode,
    this.inputType = TextInputType.text,
    this.maxLines = 1, 
    this.expands = false,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;
  final int maxLines;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166.w,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autocorrect: true,
        keyboardType: inputType,
        textCapitalization: TextCapitalization.none,
        style: GoogleFonts.titanOne(
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        maxLines: maxLines, 
        expands: expands, 
        decoration: InputDecoration(
          filled: true,
          
          fillColor: Colors.black12.withOpacity(0.7),
          label: focusNode.hasFocus || controller.text.isNotEmpty
              ? null
              : Padding(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.titanOne(
                  color: const Color.fromARGB(255, 188, 95, 190),
                  fontWeight: FontWeight.w300,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 188, 95, 190),
              width: 3.w,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 188, 95, 190),
              width: 3.w,
            ),
          ),
        ),
      ),
    );
  }
}
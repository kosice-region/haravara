import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FormRow extends StatelessWidget {
  const FormRow({
    Key? key,
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.inputType,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;
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
            color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          label: focusNode.hasFocus || controller.text.isNotEmpty
              ? null
              : Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      title,
                      style: GoogleFonts.titanOne(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3.w,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3.w,
            ),
          ),
        ),
      ),
    );
  }
}

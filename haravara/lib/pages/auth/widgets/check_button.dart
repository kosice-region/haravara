import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckButton extends StatefulWidget {
  const CheckButton({
    Key? key,
    required this.value,
    required this.text,
    required this.onChanged,
    this.hasClickablePart = false,
    this.clickableText = '',
    this.onClickableTextTap,
    this.secondClickableText = '',
    this.onSecondClickableTextTap,
  }) : super(key: key);

  final bool value;
  final String text;
  final ValueChanged<bool> onChanged;
  final bool hasClickablePart;
  final String clickableText;
  final VoidCallback? onClickableTextTap;
  final String secondClickableText;
  final VoidCallback? onSecondClickableTextTap;

  @override
  State<CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.value;

    return SizedBox(
      height: 25.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            activeColor: const Color.fromARGB(255, 155, 221, 153),
            value: isChecked,
            onChanged: (value) {
              log('CheckButton changed: $value');
              widget.onChanged(value!);
            },
          ),
          Expanded(
            child: widget.hasClickablePart
                ? RichText(
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    text: TextSpan(
                      style: GoogleFonts.titanOne(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 11.sp,
                      ),
                      children: [
                        TextSpan(
                          text: '${widget.text} ',
                        ),
                        TextSpan(
                          text: widget.clickableText,
                          style: GoogleFonts.titanOne(
                            color: Color.fromARGB(255, 255, 221, 0),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w300,
                            fontSize: 11.sp,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (widget.onClickableTextTap != null) {
                                widget.onClickableTextTap!();
                              }
                            },
                        ),
                        if (widget.secondClickableText.isNotEmpty) ...[
                          TextSpan(
                            text: ' a ',
                          ),
                          TextSpan(
                            text: widget.secondClickableText,
                            style: GoogleFonts.titanOne(
                              color: Color.fromARGB(255, 255, 221, 0),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w300,
                              fontSize: 11.sp,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (widget.onSecondClickableTextTap != null) {
                                  widget.onSecondClickableTextTap!();
                                }
                              },
                          ),
                        ],
                      ],
                    ),
                  )
                : Text(
                    widget.text,
                    style: GoogleFonts.titanOne(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 11.sp,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

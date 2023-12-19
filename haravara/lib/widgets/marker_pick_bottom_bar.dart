import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkerPickBottomBar extends StatefulWidget {
  const MarkerPickBottomBar(
      {super.key,
      required this.title,
      required this.body,
      required this.onPressed});

  final String title;
  final String body;
  final void Function() onPressed;

  @override
  State<MarkerPickBottomBar> createState() => _MarkerPickBottomBarState();
}

class _MarkerPickBottomBarState extends State<MarkerPickBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 340.w,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 248, 65, 65),
            ),
            child: Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(height: 13.h),
                      Text(
                        widget.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                          color: Colors.amber,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.body,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                            color: const Color.fromARGB(255, 187, 137, 196),
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 17, 114),
                      ),
                      onPressed: widget.onPressed,
                      child: Text(
                        'Select',
                        style: GoogleFonts.titanOne(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

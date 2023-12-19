import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/location_place.dart';
import 'package:haravara/models/location_places.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.location,
    required this.onPressed,
  });

  final LocationPlace location;
  final void Function(LocationPlaces) onPressed;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 370.w,
            height: 257.h,
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
                      Text(
                        widget.location.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                          color: Colors.amber,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.location.quantity.toString()} locations',
                        style: GoogleFonts.titanOne(
                            color: const Color.fromARGB(255, 187, 137, 196),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      SizedBox(width: 42.w),
                      SizedBox(
                        width: 140.w,
                        height: 100.h,
                        child: Image.asset(widget.location.images[0],
                            fit: BoxFit.cover),
                      ),
                      SizedBox(width: 15.w),
                      SizedBox(
                        width: 140.w,
                        height: 100.h,
                        child: Image.asset(widget.location.images[1],
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 17, 114),
                      ),
                      onPressed: () =>
                          widget.onPressed(widget.location.locationPlaces),
                      child: Text(
                        'Select',
                        style: GoogleFonts.titanOne(
                            color: Colors.white,
                            fontSize: 16.sp,
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

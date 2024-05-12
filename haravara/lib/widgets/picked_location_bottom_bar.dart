import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PickedLocationBottomBar extends StatefulWidget {
  const PickedLocationBottomBar({
    super.key,
    required this.location,
    required this.onStop,
    this.distance,
    required this.onPrize,
  });

  final String location;
  final double? distance;
  final void Function() onStop;
  final void Function() onPrize;
  @override
  State<PickedLocationBottomBar> createState() =>
      _PickedLocationBottomBarState();
}

class _PickedLocationBottomBarState extends State<PickedLocationBottomBar> {
  bool isNearPoint = false;

  String getCurrentString(double distance) {
    if (distance > 25.0) {
      return 'You are in ${distance.toStringAsFixed(2)} meters';
    }
    if (distance <= 25) {
      isNearPoint = true;
      return 'You are here\n Get a new prize';
    }
    isNearPoint = true;
    return 'You are nearby';
  }

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.titanOne(
        color: const Color.fromARGB(255, 189, 38, 169),
        fontSize: 20.sp,
        fontWeight: FontWeight.w300);
    return Column(
      children: [
        Center(
          child: Container(
            width: 360.w,
            height: 220.h,
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
                        'HEY!',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                          color: const Color.fromARGB(255, 189, 38, 169),
                          fontSize: 45.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      if (widget.distance == null)
                        Text(
                          'Exploring location \n ${widget.location}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: style,
                        ),
                      if (widget.distance != null)
                        Text(
                          getCurrentString(widget.distance!),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: style,
                        ),
                      if (widget.distance != null && widget.distance! > 25)
                        Text(
                          'CARRY ON!',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: GoogleFonts.titanOne(
                              color: const Color.fromARGB(255, 6, 38, 169),
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w300),
                        ),
                    ],
                  ),
                  if (!isNearPoint)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 17, 114),
                      ),
                      onPressed: widget.onStop,
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.titanOne(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (isNearPoint)
                    Column(
                      children: [
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 6, 17, 114),
                          ),
                          onPressed: widget.onStop,
                          child: Text(
                            'Prize',
                            style: GoogleFonts.titanOne(
                                color: Colors.white,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

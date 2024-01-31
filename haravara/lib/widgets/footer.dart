import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as Flutter;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Footer extends StatelessWidget {
  const Footer({this.boxFit = BoxFit.cover, super.key, required this.height});
  final int height;
  final BoxFit boxFit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 271.w,
      child: Flutter.Image.asset(
        'assets/background.png',
        fit: boxFit,
        height: height.h,
      ),
    );
  }
}

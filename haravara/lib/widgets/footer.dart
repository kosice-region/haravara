import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as Flutter;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Flutter.Image.asset(
        'assets/background.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

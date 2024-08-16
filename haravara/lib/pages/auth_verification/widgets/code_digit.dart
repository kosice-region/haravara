import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CodeDigit extends StatelessWidget {
  const CodeDigit({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    // Assuming the parent container has enough width
    // Adjusting the width factor and positioning
    double digitWidth = 25.w;
    double spacing = 8.w;
    double leftPosition = index * (digitWidth + spacing);

    return Positioned(
      top: 0,
      bottom: 0,
      left: leftPosition,
      child: Container(
        width: digitWidth,
        height: 45.h,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 231, 179, 51),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}

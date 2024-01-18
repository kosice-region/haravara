import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatefulWidget {
  const Header({super.key, required this.showMenu});
  final bool showMenu;
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 80.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 30.w),
                Image(
                  image: const AssetImage('assets/logo-haravara.png'),
                  fit: BoxFit.cover,
                  width: 140.w,
                  height: 90.h,
                ),
                SizedBox(width: 150.w),
                if (widget.showMenu)
                  Container(
                    height: 55.h,
                    width: 65.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 177, 235, 183),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 13.h),
                        SizedBox(
                          height: 4.h,
                          width: 43.w,
                          child: const ColoredBox(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 4.h,
                          width: 43.w,
                          child: const ColoredBox(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 4.h,
                          width: 43.w,
                          child: const ColoredBox(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            )
          ],
        ));
  }
}

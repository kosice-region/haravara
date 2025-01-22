import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/admin/view/screens/admin_menu_screen.dart';


class FooterAdmin extends ConsumerWidget {
  FooterAdmin(
      {super.key,
      this.height = 50,
      this.showMenu = true});
  final double height;
  final bool showMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (showMenu) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const AdminMenu(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 150),
            ),
          );
        }
      },
      child: Container(
        height: height.h,
        color: const Color.fromRGBO(41, 141, 116, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const AdminMenu(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 150),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 3.5.h, width: 35.48.w, child: const ColoredBox(color: Colors.black)),
                      SizedBox(height: 8.h),
                      SizedBox(height: 3.5.h, width: 35.48.w, child: const ColoredBox(color: Colors.black)),
                      SizedBox(height: 8.h),
                      SizedBox(height: 3.5.h, width: 35.48.w, child: const ColoredBox(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: ElevatedButton(
                onPressed: () => _verifyCode(context),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(100.w, 30.h), // Customize button size
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.white, width: 4),
                ),
                child: Text(
                  'Potvrď',
                  style: GoogleFonts.titanOne(
                    fontSize: 13.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCode(BuildContext context) {
    // Your verification logic here
    log("Verifying Code...");
  }
}

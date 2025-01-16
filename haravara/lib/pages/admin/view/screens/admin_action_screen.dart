import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';

class AdminActionScreen extends ConsumerWidget {
  final String titleText;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onButtonPressed;
  final VoidCallback onMenuPressed;
  final double? buttonWidth;
  final String username;
  final String type;       
  final int children;      
  final String rewardName; 

  const AdminActionScreen({
    Key? key,
    required this.titleText,
    required this.buttonText,
    required this.buttonColor,
    required this.onButtonPressed,
    required this.onMenuPressed,
    required this.username,
    required this.type,
    required this.children,
    required this.rewardName,
    this.buttonWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFamily = type == 'family';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/backgrounds/verification_background.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  height: 50.h,
                  color: const Color.fromRGBO(41, 141, 116, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: GestureDetector(
                          onTap: onMenuPressed,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
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
                        padding: EdgeInsets.only(right: 8.w),
                        child: ElevatedButton(
                          onPressed: onButtonPressed,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(buttonWidth ?? 85.w, 33.h),
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: const BorderSide(color: Colors.white, width: 4),
                          ),
                          child: Text(
                            buttonText,
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Column(
                children: [
                  const Header(),
                  SizedBox(height: 20.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 210.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9260A8),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Text(
                            titleText,
                            style: GoogleFonts.titanOne(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: isFamily ? 130.w : 210.w, 
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 23.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE65F33),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: Text(
                                username,
                                style: GoogleFonts.titanOne(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          if (isFamily) ...[
                            SizedBox(width: 10.w),
                            SizedBox(
                              width: 70.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 8.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE65F33),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Colors.white, width: 4),
                                ),
                                child: Text(
                                  'Počet detí: $children',
                                  style: GoogleFonts.titanOne(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 210.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Text(
                            'Cena: $rewardName',
                            style: GoogleFonts.titanOne(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50.h,
              right: 30.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.transparent,
                  ),
                  child: Image.asset(
                    'assets/menu-icons/backbutton.png',
                    width: 36.w,
                    height: 36.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

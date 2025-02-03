import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/reward_menu/model/reward_model.dart';

import '../../../core/widgets/close_button.dart';

class RewardDetailsScreen extends StatelessWidget {
  final Reward reward;
  final String username;

  const RewardDetailsScreen({
    Key? key,
    required this.reward,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
              Footer(height: 50),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Column(
              children: [
                Header(),
                SizedBox(height: 5.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.h),
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
                            'Gratulujeme $username k vyzbieraným pečiatkám.\nPouži kód k prevziatiu ceny',
                            style: GoogleFonts.titanOne(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 210.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE65F33),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Column(
                            children: [
                              Text(
                                username,
                                style: GoogleFonts.titanOne(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                reward.code,
                                style: GoogleFonts.titanOne(
                                  fontSize: 26.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 210.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF59B84A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Text(
                            'Cena: ${reward.prize}',
                            style: GoogleFonts.titanOne(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 210.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2AB1FF),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Text(
                            'Vyzdvihnutie Ceny:\n Regionálny informačný bod, Hlavná 48,                040 01 Košice',
                            style: GoogleFonts.titanOne(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(),
          ),
        ],
      ),
    );
  }
}

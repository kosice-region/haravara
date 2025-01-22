import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/admin/view/screens/special_rewards/special_reward_users_screen.dart';

class SpecialRewardScreen extends StatelessWidget {
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
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h),
            child: const Header(),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildRewardButton(
                  context,
                  '30 pečiatok',
                  const Color(0xFFE65F33),
                  rewardLevel: 30,
                ),
                SizedBox(height: 20.h),
                buildRewardButton(
                  context,
                  '45 pečiatok',
                  const Color(0xFF59B84A),
                  rewardLevel: 45,
                ),
              ],
            ),
          ),

          Positioned(
            top: 67.h,
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
    );
  }

  Widget buildRewardButton(BuildContext context, String buttonText, Color color, {required int rewardLevel}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecialRewardUsersScreen(rewardLevel: rewardLevel),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(150.w, 40.h),
        backgroundColor: color,
        side: const BorderSide(color: Colors.white, width: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.titanOne(
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}

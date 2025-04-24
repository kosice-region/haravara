
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/pages/admin/view/screens/special_rewards/provider.dart';

import 'export_excel.dart';

class SpecialRewardUsersScreen extends ConsumerWidget {
  final int rewardLevel;

  const SpecialRewardUsersScreen({Key? key, required this.rewardLevel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: Padding(
              padding: EdgeInsets.only(top: 80.h), 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 210.w,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9260A8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        'Emaily Používateľov',
                        style: GoogleFonts.titanOne(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: 210.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: EmailList(rewardLevel: rewardLevel), 
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Container(
                    width: 210.w,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF607DA8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: GestureDetector(
                    onTap: () {
                      exportDataToExcel(context,rewardLevel);
                      },
                        child: Text(
                          'Export to Excel',
                          style: GoogleFonts.titanOne(
                          fontSize: 14.sp,
                          color: Colors.white,
                        )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 61.h,
            right: 27.w,
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
}

class EmailList extends StatelessWidget {
  final int rewardLevel;

  const EmailList({required this.rewardLevel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: getUserEmailsByRewardLevel(rewardLevel),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found with $rewardLevel or more collected places.', textAlign: TextAlign.center, style: GoogleFonts.titanOne(fontSize: 10.sp, color: Colors.white)));
        }

        final userEmails = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            children: userEmails
                .map((email) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Text(
                        email,
                        style: GoogleFonts.titanOne(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

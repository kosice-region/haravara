import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/widgets/achievement.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8).r,
            child: Column(
              children: [
                const Header(showMenu: true),
                14.verticalSpace,
                Text(
                  'TVOJE PEČIATKY',
                  style: GoogleFonts.titanOne(
                      color: const Color.fromARGB(255, 86, 162, 73),
                      fontSize: 15.sp),
                ),
                10.verticalSpace,
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (5 / 4.h),
              children: const [
                Achievement(title: 'Dom sv.Alzbety'),
                Achievement(title: 'Obisovsky hrad', isClosed: false),
                Achievement(title: 'Kosicky hrad', isClosed: false),
                Achievement(title: 'Vcely raja', isClosed: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

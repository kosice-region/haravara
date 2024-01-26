import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/widgets/achievement.dart';
import 'package:haravara/widgets/header.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          const Header(showMenu: true),
          SizedBox(height: screenHeight.h * 0.05),
          Text(
            'TVOJE PEČIATKY',
            style: GoogleFonts.titanOne(
                color: const Color.fromARGB(255, 86, 162, 73), fontSize: 28.sp),
          ),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 30.0),
              children: const [
                Achievement(),
                Achievement(),
                Achievement(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

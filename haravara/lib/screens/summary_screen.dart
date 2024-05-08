import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final List<String> imageAssets = [
    'assets/background-summary.png',
    'assets/budik.png',
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Image.asset(
            'assets/background-summary.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              8.verticalSpace,
              const Header(),
              30.verticalSpace,
              Text(
                'TERMINY SUTAZI',
                style: GoogleFonts.titanOne(
                    fontSize: 18.sp,
                    color: const Color.fromARGB(255, 86, 162, 73),
                    fontWeight: FontWeight.w500),
              ),
              10.verticalSpace,
              summaryItem(),
              summaryItem(),
              summaryItem(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Footer(height: 40),
          ),
        ],
      ),
    );
  }

  Widget summaryItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow outside of the stack
        children: [
          Container(
            width: 195.w,
            height: 62.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)).r,
              color: const Color.fromARGB(255, 177, 235, 183),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 91, 187, 75).withOpacity(1),
                  spreadRadius: 8,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          Positioned(
            top: -15.h,
            left: -20.w,
            child: Image.asset(
              'assets/budik.png',
              width: 60.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

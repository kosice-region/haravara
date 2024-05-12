import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart'; // Import Footer widget

class PrizesScreen extends StatefulWidget {
  const PrizesScreen({Key? key}) : super(key: key);

  @override
  _PrizesScreenState createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  final List<String> imageAssets = [
    'assets/clovece.jpg',
    'assets/MINCE.png',
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Image.asset(
            'assets/clovece.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              8.verticalSpace,
              const Header(),
              10.verticalSpace,
              Text(
                'VYHRY',
                style: GoogleFonts.titanOne(
                    fontSize: 18.sp,
                    color: Color.fromARGB(255, 255, 93, 93),
                    fontWeight: FontWeight.w500),
              ),
              10.verticalSpace,
              summaryItem(),
              summaryItem(),
              summaryItem(),
            ],
          ),
        ],
      ),
      bottomSheet: const Footer(
          height: 175,
          boxFit: BoxFit.fill), // Add the Footer widget as bottomSheet
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
              color: Color.fromARGB(255, 255, 93, 93),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 93, 93).withOpacity(1),
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
              'assets/MINCE.png',
              width: 60.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

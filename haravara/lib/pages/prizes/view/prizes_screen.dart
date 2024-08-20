import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';

import '../widgets/widgets.dart';

class PrizesScreen extends StatefulWidget {
  const PrizesScreen({Key? key}) : super(key: key);

  @override
  _PrizesScreenState createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  final List<String> imageAssets = [
    'assets/backgrounds/background.jpg',
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
            'assets/backgrounds/background.jpg',
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
              for (var i = 0; i < 3; i++) SummaryItem(),
            ],
          ),
        ],
      ),
      bottomSheet: Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/conditions/widgets/widgets.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/core/widgets/footer.dart';

class PodmienkyScreen extends StatefulWidget {
  const PodmienkyScreen({Key? key}) : super(key: key);

  @override
  _PodmienkyScreenState createState() => _PodmienkyScreenState();
}

class _PodmienkyScreenState extends State<PodmienkyScreen> {
  final List<String> imageAssets = [
    'assets/background.jpg',
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
              const Header(),
              4.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'PODMIENKY SÚŤAŽE',
                    style: GoogleFonts.titanOne(
                      fontSize: 15.sp,
                      color: const Color.fromARGB(255, 249, 64, 64),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior().copyWith(overscroll: false),
                        child: CustomScrollbar(
                          child: SummaryItem(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.h,
                      left: -13.w,
                      child: Image.asset(
                        'assets/avatars/KASO_CITA (1).png',
                        width: 50.w,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}

class CustomScrollbar extends StatelessWidget {
  final Widget child;

  const CustomScrollbar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 8.w, 
      radius: Radius.circular(10.r),
      thumbVisibility: true, 
      trackVisibility: true,
      interactive: true,
      child: child,
    );
  }
}

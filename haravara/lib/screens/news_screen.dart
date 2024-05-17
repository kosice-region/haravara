import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/auth_service.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  List<String> texts = [
    'Tipy na výlety: Nechajte sa inšpirovať našimi tipmi na rodinné výlety a pripravte sa na poriadne dobrodružstvo.',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis quis ex eu ante tempus molestie eu eget leo.',
    'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.'
  ];

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final List<String> imageAssets = [
    'assets/pozadie8.jpg',
    'assets/MAX s horalkou.png',
    'assets/Majka pri ohni.png',
    'assets/BATOH (1).png',
  ];

  @override
  void initState() {
    super.initState();
    initPlaces();
  }

  initPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('${prefs.getStringList('collectedPlaces')}');
    final places = await DatabaseService().loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
  }

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    ScreenUtil.init(context, designSize: const Size(255, 516));

    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Image.asset(
              'assets/pozadie8.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                const Header(),
                const SizedBox(height: 80),
                SizedBox(
                  height: 150.h,
                  width: 215.w,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: texts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: buildBox(texts[index]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: texts.length,
                    effect: SlideEffect(
                      spacing: 8.0,
                      radius: 4.0,
                      dotWidth: 20.0,
                      dotHeight: 8.0,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: const Color.fromRGBO(205, 19, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 3,
            child: Image.asset(
              'assets/MAX s horalkou.png',
              height: 164.h,
            ),
          ),
          Positioned(
            bottom: 20,
            right: -12,
            child: Transform.scale(
              scale: 1.2,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14),
                child: Image.asset(
                  'assets/Majka pri ohni.png',
                  height: 164.h,
                ),
              ),
            ),
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

  Widget buildBox(String text) {
    double padding = 20;
    double maxWidth = 224.w - padding * 2;

    Size textSize =
        calculateTextSize(text, TextStyle(fontSize: 12.sp), maxWidth);

    double containerHeight = textSize.height + padding * 7;

    return Container(
      width: 215.w,
      height: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color.fromARGB(255, 157, 214, 246),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 157, 214, 246).withOpacity(1),
            spreadRadius: 8,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: Image.asset(
              'assets/BATOH (1).png',
              width: 80.w,
              height: 80.h,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  maxLines: 6,
                  style: GoogleFonts.titanOne(
                    color: const Color.fromRGBO(205, 19, 175, 1),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Size calculateTextSize(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    return textPainter.size;
  }
}

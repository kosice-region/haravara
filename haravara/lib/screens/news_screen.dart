import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/places_service.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart';

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

  @override
  void initState() {
    super.initState();
    initPlaces();
  }

  initPlaces() async {
    final places = await PlacesService().loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
    for (var place in places) {
      if (place.isReached) {
        print('2 place ${place.name} isReached = ${place.isReached}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    return Scaffold(
      endDrawer: const HeaderMenu(),
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
            padding: const EdgeInsets.only(top: 8).h,
            child: Column(
              children: [
                const Header(),
                43.verticalSpace,
                SizedBox(
                  height: 130.h,
                  width: 230.w, // Zmena výšky PageView
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: texts.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 100.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 8.0),
                          child: buildBox(texts[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
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
    double padding = 20; // Zmena veľkosti paddingu
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

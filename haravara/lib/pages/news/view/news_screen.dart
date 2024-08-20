import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/pages/auth/services/auth_service.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../map_detail/map_detail.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  List<String> texts = [
    'PÁTRAJ, NÁJDI A VYHRAJ!',
  ];

  final List<String> imageAssets = [
    'assets/backgrounds/pozadie8.jpg',
    'assets/avatars/KASO DETEKTIV.png',
  ];

  @override
  void initState() {
    super.initState();
    initPlaces();
  }

  initPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final places = await DatabaseService().loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
  }

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    ScreenUtil.init(context, designSize: const Size(255, 516));

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/haravara_1.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
              Footer(height: 50),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              children: [
                Header(),
                20.verticalSpace,
                SizedBox(
                  height: 180.h,
                  width: 190.w,
                  child: buildBox(),
                ),
                30.verticalSpace,
                ElevatedButton(
                  onPressed: () {
                    routeToNextScreen(context, ScreenType.prizes, ref);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(190.w, 40.h),
                    backgroundColor: const Color.fromARGB(255, 91, 187, 75),
                  ),
                  child: Text(
                    'VÝHRY',
                    style: GoogleFonts.titanOne(
                        fontSize: 12.sp, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    routeToNextScreen(context, ScreenType.podmienky, ref);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(190.w, 40.h),
                    backgroundColor: const Color(0xFFFFC944),
                  ),
                  child: Text(
                    'PODMIENKY SÚŤAŽE',
                    style: GoogleFonts.titanOne(
                        fontSize: 12.sp, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(4.w), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: const Color.fromARGB(255, 157, 214, 246),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 157, 214, 246).withOpacity(1),
            spreadRadius: 8,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, 
        children: [
          Positioned(
            left: 20.w, 
            top: 20,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/avatars/KASO DETEKTIV.png',
                width: 140.w,
                height: 140.h,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, top: 20), 
            child: Column(
              children: [
                Text(
                  texts[0],
                  style: GoogleFonts.titanOne(
                    color: const Color.fromARGB(255, 191, 0, 159),
                    fontSize: 11.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Zober svojich rodičov a kamarátov na úžasnú cestu po krajine Haravara a získaj všetky Kaškove pečiatky!\nAktuálna sezóna Haravara Pátračky trvá do konca roka 2024!',
                  style: GoogleFonts.titanOne(
                    color: const Color.fromARGB(255, 191, 0, 159),
                    fontSize: 8.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.h, 
            left: 100,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  routeToNextScreen(context, ScreenType.map, ref);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(120.w, 35.h),
                  backgroundColor: const Color(0xFFFFC944),
                ),
                child: Text(
                  'IDEM PÁTRAŤ',
                  style:
                      GoogleFonts.titanOne(fontSize: 9.sp, color: Colors.black),
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

void routeToNextScreen(context, ScreenType screenToRoute, WidgetRef ref) {
  var currentScreen = ref.watch(routerProvider);
  if (currentScreen == screenToRoute) {
    return;
  }
  ref.read(routerProvider.notifier).changeScreen(screenToRoute);
  ScreenRouter().routeToNextScreenWithoutAllowingRouteBackWithoutAnimation(
      context, ScreenRouter().getScreenWidget(screenToRoute));
}

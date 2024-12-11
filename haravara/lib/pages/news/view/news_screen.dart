import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                40.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      buildBox(),
                      SizedBox(height: 10.h),
                      Column(
                        children: [
                          buildResponsiveButton(
                            label: 'REBRÍČEK',
                            color: const Color.fromARGB(255, 205, 105, 167),
                            screen: ScreenType.leaderBoardLevels,
                            ref: ref,
                          ),
                          SizedBox(height: 10.h),
                          buildResponsiveButton(
                            label: 'PODMIENKY SÚŤAŽE',
                            color: const Color.fromARGB(255, 60, 200, 90),
                            screen: ScreenType.podmienky,
                            ref: ref,
                          ),
                        ],
                      ),
                    ],
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
    double deviceHeight = MediaQuery.of(context).size.height;
    double containerHeight = 160.h;
    double imageHeight = 140.h;

    if (deviceHeight < 850) {
      containerHeight = 160.h;
      imageHeight = 180.h;
    }
    if (deviceHeight < 700) {
      containerHeight = 190.h;
      imageHeight = 180.h;
    }
    if (deviceHeight < 650) {
      containerHeight = 190.h;
      imageHeight = 60.h;
    }

    return Container(
      width: 230.w,
      height: containerHeight,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: const Color.fromARGB(255, 24, 191, 186),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 20.w,
            top: 20,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/avatars/KASO DETEKTIV.png',
                width: 140.w,
                height: imageHeight, // Adjusted image height
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
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 11.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
                SizedBox(height: 10.h),
                Text(
                  'Zober svojich rodičov a kamarátov na úžasnú cestu po krajine Haravara a získaj všetky Kaškove pečiatky!\nAktuálna sezóna Haravara Pátračky trvá do konca roka 2024!',
                  style: GoogleFonts.titanOne(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 9.sp,
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
                  backgroundColor: const Color.fromARGB(255, 239, 72, 77),
                  side: BorderSide(color: Colors.white, width: 4),
                ),
                child: Text(
                  'IDEM PÁTRAŤ',
                  style: GoogleFonts.titanOne(
                      fontSize: 9.sp,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResponsiveButton({
    required String label,
    required Color color,
    required ScreenType screen,
    required WidgetRef ref,
  }) {
    return ElevatedButton(
      onPressed: () {
        routeToNextScreen(context, screen, ref);
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(170.w, 40.h),
        backgroundColor: color,
        side: BorderSide(color: Colors.white, width: 4),
      ),
      child: Text(
        label,
        style: GoogleFonts.titanOne(
          fontSize: 12.sp,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
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

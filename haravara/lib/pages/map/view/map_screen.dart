import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/map/widgets/widgets.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> imageAssets = [
    'assets/places-map.jpg',
    'assets/peopleMapScreen.png',
    'assets/backgrounds/background_dark_green.png',
    'assets/foreground_overlay.png', // Add your foreground image here
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 232, 209),
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/backgrounds/background_dark_green.png',
              fit: BoxFit.cover,
              height: 200.h,
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/peopleMapScreen.png',
              fit: BoxFit.contain,
              height: 130.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Column(
              children: [
                const Header(),
                10.verticalSpace,
                Center(
                  child: Text(
                    'MAPA PEČIATOK',
                    style: GoogleFonts.titanOne(
                      fontSize: 17.sp,
                      color: const Color.fromARGB(255, 86, 162, 73),
                    ),
                  ),
                ),
                MapPreview(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 86, 162, 73),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlacesListScreen()),
                    );
                  },
                  child: Text(
                    'ZOZNAM PEČIATOK',
                    style: GoogleFonts.titanOne(
                      fontSize: 14.sp,
                      color: Color.fromARGB(255, 244, 232, 209),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as Flutter;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/screens/achievements.dart';
import 'package:haravara/screens/map_screen.dart';
import 'package:haravara/screens/summary_screen.dart';
import 'package:haravara/widgets/header_menu.dart';

class Footer extends StatelessWidget {
  const Footer({this.boxFit = BoxFit.cover, Key? key, required this.height});
  final int height;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Otvorenie menu
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HeaderMenu(),
        ));
      },
      child: Container(
        height: 40.h, // 3 cm in logical pixels
        color: const Color.fromRGBO(41, 141, 116, 1), // Zelená farba banneru
        child: Row(
          children: [
            const SizedBox(width: 14), // Posun obsahu doprava
            Column(
              children: [
                8.33.verticalSpace,
                SizedBox(width: 8.w), // Prispôsobte šírku podľa potreby
                SizedBox(
                  height: 3.5.h,
                  width: 35.48.w, // Prispôsobte šírku podľa potreby
                  child: const ColoredBox(
                    color: Colors.black,
                  ),
                ),
                8.33.verticalSpace,
                SizedBox(
                  height: 3.5.h,
                  width: 35.48.w, // Prispôsobte šírku podľa potreby
                  child: const ColoredBox(
                    color: Colors.black,
                  ),
                ),
                8.33.verticalSpace,
                SizedBox(
                  height: 3.5.h,
                  width: 35.48.w, // Prispôsobte šírku podľa potreby
                  child: const ColoredBox(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0,
                        right: 35.0), // Zmenené na left a pridané right
                    child: IconButton(
                      icon: Image.asset(
                          'assets/Icon.jpeg'), // Replace with your actual image path
                      onPressed: () {
                        // Action when the button is pressed
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AchievementsScreen(), // Placeholder container, replace with your desired screen
                        ));
                      },
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                        'assets/menu-icons/map.png'), // Replace with your actual image path
                    onPressed: () {
                      // Action when the button is pressed
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MapScreen(), // Placeholder container, replace with your desired screen
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/services/screen_router.dart';
import 'package:haravara/widgets/header_menu.dart';

class Footer extends ConsumerWidget {
  const Footer({super.key, this.boxFit = BoxFit.cover, required this.height});
  final int height;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Otvorenie menu
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HeaderMenu(),
        ));
      },
      child: Container(
        height: 50.h, // 3 cm in logical pixels
        color: const Color.fromRGBO(41, 141, 116, 1), // Zelená farba banneru
        child: Row(
          children: [
            const SizedBox(width: 16), // Posun obsahu doprava
            Column(
              children: [
                12.verticalSpace,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 2),
                  IconButton(
                    iconSize: 40.0,
                    icon: Image.asset('assets/Icon.jpeg'),
                    onPressed: () {
                      routeToNextScreen(context, ScreenType.achievements, ref);
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/menu-icons/map.png'),
                    onPressed: () {
                      routeToNextScreen(context, ScreenType.map, ref);
                    },
                  ),
                  IconButton(
                    iconSize: 60.0,
                    icon: Image.asset('assets/profil.png'),
                    onPressed: () {
                      routeToNextScreen(context, ScreenType.profile, ref);
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

  void routeToNextScreen(context, ScreenType screenToRoute, WidgetRef ref) {
    var currentScreen = ref.watch(currentScreenProvider);
    if (currentScreen == screenToRoute) {
      return;
    }
    ref.read(currentScreenProvider.notifier).changeScreen(screenToRoute);
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBackWithoutAnimation(
        context, ScreenRouter().getScreenWidget(screenToRoute));
  }
}

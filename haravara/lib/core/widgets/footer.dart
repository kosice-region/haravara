import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';

class Footer extends ConsumerWidget {
  Footer(
      {super.key,
      this.boxFit = BoxFit.cover,
      required this.height,
      this.showMenu = true});
  final int height;
  final BoxFit boxFit;
  final bool showMenu;
  final List<String> imageAssets = [
    'assets/PECIATKA.png',
    'assets/menu-icons/map.png',
    'assets/menu-icons/map.png',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return GestureDetector(
      onTap: () {
        if (showMenu) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HeaderMenu(),
          ));
        }
      },
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.0,
              0.1,
              1.0
            ], // Specify where the color changes should happen
            colors: [
              Color(0xFF95FFE4), // Color at position 0%
              Color(0xFF298D74), // Color at position 10%
              Color(0xFF298D74), // Keep Color at 100%
            ],
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Column(
              children: [
                12.verticalSpace,
                SizedBox(width: 8.w),
                SizedBox(
                  height: 3.5.h,
                  width: 35.48.w,
                  child: const ColoredBox(
                    color: Colors.black,
                  ),
                ),
                8.33.verticalSpace,
                SizedBox(
                  height: 3.5.h,
                  width: 35.48.w,
                  child: const ColoredBox(
                    color: Colors.black,
                  ),
                ),
                8.33.verticalSpace,
                SizedBox(
                  height: 3.5.h,
                  width: 35.48.w,
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
                    icon: Image.asset('assets/PECIATKA.png'),
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
                  Consumer(
                    builder: (context, ref, child) {
                      final currentAvatar =
                          ref.watch(avatarsProvider).getCurrentAvatar();
                      return IconButton(
                        onPressed: () {
                          routeToNextScreen(context, ScreenType.profile, ref);
                        },
                        icon: ClipOval(
                          child: Image.file(
                            File(currentAvatar.location!),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void routeToNextScreen(context, ScreenType screenToRoute, WidgetRef ref) {
    var currentScreen = ref.watch(routerProvider);
    if (currentScreen == ScreenType.menu && currentScreen != screenToRoute) {
      ref.read(routerProvider.notifier).changeScreen(screenToRoute);
      ScreenRouter().routeToNextScreenWithoutAllowingRouteBackWithoutAnimation(
          context, ScreenRouter().getScreenWidget(screenToRoute));
      Navigator.of(context).pop();
      return;
    }
    ref.read(routerProvider.notifier).changeScreen(screenToRoute);
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBackWithoutAnimation(
        context, ScreenRouter().getScreenWidget(screenToRoute));
  }
}

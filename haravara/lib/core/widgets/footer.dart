import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';

class Footer extends ConsumerWidget {
  Footer({
    super.key,
    this.boxFit = BoxFit.cover,
    required this.height,
    this.showMenu = true,
  });

  final int height;
  final BoxFit boxFit;
  final bool showMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 50.h, 
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.1, 1.0],
          colors: const [
            Color(0xFF95FFE4),
            Color(0xFF298D74),
            Color(0xFF298D74),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hamburger Menu

          _footerIcon(
            context,
            ref,
            'assets/menu.png',
            ScreenType.menu,
            size: 28.w,
          ),


          // Left icon - Peciatka
          _footerIcon(
            context,
            ref,
            'assets/PECIATKA.png',
            ScreenType.achievements,
            size: 40.w,
          ),

          // Home Icon - Centered
          _footerIcon(
            context,
            ref,
            'assets/home_button.png',
            ScreenType.news,
            size: 36.w,
          ),

          // Right icon - Map
          _footerIcon(
            context,
            ref,
            'assets/menu-icons/map.png',
            ScreenType.map,
            size: 40.w,
          ),

          // Profile Icon 
          Consumer(
            builder: (context, ref, child) {
              final currentAvatar =
                  ref.watch(avatarsProvider).getCurrentAvatar();
              return SizedBox(
                width: 36.w,
                height: 36.h,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 34.0,
                  onPressed: () {
                    routeToNextScreenWithoutAnimation(context, ScreenType.profile, ref);
                  },
                  icon: ClipOval(
                    child: Image.file(
                      width: 52,
                      height: 52,
                      File(currentAvatar.location!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _footerIcon(
      BuildContext context, WidgetRef ref, String asset, ScreenType screen,
      {double size = 30}) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Image.asset(asset, fit: BoxFit.contain),
        onPressed: () {
          routeToNextScreenWithoutAnimation(context, screen, ref);
        },
      ),
    );
  }

  void routeToNextScreenWithoutAnimation(
      BuildContext context, ScreenType screenToRoute, WidgetRef ref) {
    final currentScreen = ref.watch(routerProvider);

    if (currentScreen == screenToRoute) return;

    ref.read(routerProvider.notifier).changeScreen(screenToRoute);
    ScreenRouter().routeToNextScreenWithoutAnimation(
      context,
      ScreenRouter().getScreenWidget(screenToRoute),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
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
    final currentAvatar = ref.watch(avatarsProvider).getCurrentAvatar();
    log('Footer: Avatar location: ${currentAvatar.location}, Exists: ${currentAvatar.location != null && File(currentAvatar.location!).existsSync()}');

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Image.asset(
              'assets/menu.png',
              fit: BoxFit.contain,
              scale: 20,
            ),
            onPressed: () {
              if (ModalRoute.of(context)!.settings.name == '/headerMenu') {
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HeaderMenu(),
                  settings: const RouteSettings(name: '/headerMenu'),
                ),
              );
            },
          ),
          _footerIcon(
            context,
            ref,
            'assets/PECIATKA.png',
            ScreenType.achievements,
            size: 40.w,
          ),
          _footerIcon(
            context,
            ref,
            'assets/home_button.png',
            ScreenType.news,
            size: 36.w,
          ),
          _footerIcon(
            context,
            ref,
            'assets/menu-icons/map.png',
            ScreenType.map,
            size: 40.w,
          ),
          SizedBox(
            width: 36.w,
            height: 36.h,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 34.0,
              onPressed: () {
                routeToNextScreenWithoutAnimation(
                    context, ScreenType.profile, ref);
              },
              icon: ClipOval(
                child: _buildAvatarImage(currentAvatar),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(UserAvatar currentAvatar) {
    if (currentAvatar.location == null ||
        !File(currentAvatar.location!).existsSync()) {
      log('Footer: Falling back to default avatar due to invalid location or non-existent file');
      return Image.asset(
        'assets/avatars/kasko.png',
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      );
    }
    try {
      return Image.file(
        File(currentAvatar.location!),
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          log('Footer: Image.file error: $error, falling back to default avatar');
          return Image.asset(
            'assets/avatars/kasko.png',
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          );
        },
      );
    } catch (e) {
      log('Footer: Exception loading avatar: $e, falling back to default avatar');
      return Image.asset(
        'assets/avatars/kasko.png',
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      );
    }
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class Close_Button extends ConsumerWidget {
  final ScreenType? screenType;
  final bool shouldPop;

  Close_Button({this.screenType, this.shouldPop = false});

  void routeToNextScreen(context, ScreenType screenToRoute, WidgetRef ref) {
    var currentScreen = ref.watch(routerProvider);
    if (currentScreen == screenToRoute) {
      return;
    }
    ref.read(routerProvider.notifier).changeScreen(screenToRoute);
    ScreenRouter().routeToNextScreen(
        context, ScreenRouter().getScreenWidget(screenToRoute));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    precacheImage(
        const AssetImage('assets/menu-icons/backbutton.png'), context);
    return GestureDetector(
      onTap: () {
        log("issAdmin"+ref.read(sharedPreferencesProvider).getBool('isAdmin').toString() ?? "false");

        if((ref.read(sharedPreferencesProvider).getBool('isAdmin') ?? false) ){
          routeToNextScreen(context, ScreenType.admin, ref);
          Navigator.of(context).pop();
          return;
        }

        if (screenType != null) {
          ref.read(routerProvider.notifier).changeScreen(screenType!);
          if (shouldPop) {
            Navigator.of(context).pop();
          } else {
            ScreenRouter().routeToNextScreen(
                context, ScreenRouter().getScreenWidget(screenType!));
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)).r,
          color: Colors.transparent,
        ),
        child: Image.asset(
          'assets/menu-icons/backbutton.png',
          width: 36.w,
          height: 36.h,
        ),
      ),
    );
  }
}

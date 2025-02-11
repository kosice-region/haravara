import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Close_Button extends ConsumerWidget {
  final ScreenType? screenType;

  Close_Button({this.screenType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    precacheImage(const AssetImage('assets/menu-icons/backbutton.png'), context);
    return GestureDetector(
      onTap: () {
        if (screenType != null) {
          ref.read(routerProvider.notifier).changeScreen(screenType!);
          ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
              context, ScreenRouter().getScreenWidget(screenType!));
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
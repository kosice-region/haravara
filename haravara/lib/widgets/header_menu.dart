import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/services/screen_router.dart';

class HeaderMenu extends ConsumerWidget {
  const HeaderMenu(
      {super.key,
      this.backGroundColor = const Color.fromARGB(255, 91, 187, 75)});

  final Color backGroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background_menu.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                menuItem(context, 'NOVINKY', 'assets/menu-icons/mail.png',
                    ScreenType.news, ref),
                menuItem(context, 'MAPA', 'assets/menu-icons/map.png',
                    ScreenType.map, ref),
                menuItem(context, 'PECIATKY', 'assets/Icon.jpeg',
                    ScreenType.achievements, ref),
                menuItem(context, 'SUTAZE', 'assets/menu-icons/calendar.png',
                    ScreenType.summary, ref),
                menuItem(context, 'COMPASS', 'assets/menu-icons/steps.png',
                    ScreenType.compass, ref),
                menuItem(context, 'ODHLASIT SA', 'assets/menu-icons/steps.png',
                    ScreenType.auth, ref),
              ],
            ),
          ),
          Positioned(
              top: 60.h,
              right: 30.w,
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)).r,
                  color: Colors.red,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.clear_outlined,
                    color: Colors.white,
                    size: 13.dg,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget menuItem(context, String title, String imagePath,
      ScreenType screenToRoute, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8).r,
      child: SizedBox(
        width: 134.w,
        height: 38.h,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backGroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)).w,
            ),
          ),
          onPressed: () {
            var currentScreen = ref.watch(currentScreenProvider);
            if (screenToRoute == ScreenType.auth) {
              handleLogout(ref, context);
              return;
            }
            if (currentScreen != screenToRoute) {
              ref
                  .read(currentScreenProvider.notifier)
                  .changeScreen(screenToRoute);
              ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
                  context, ScreenRouter().getScreenWidget(screenToRoute));
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              5.horizontalSpace,
              Flexible(
                flex: 3,
                child: Text(
                  title,
                  style: GoogleFonts.titanOne(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleLogout(WidgetRef ref, context) async {
    ref.read(loginNotifierProvider.notifier).logout();
    ref.read(richedPlacesProvider.notifier).deleteAllPlaces();
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.auth));
  }
}

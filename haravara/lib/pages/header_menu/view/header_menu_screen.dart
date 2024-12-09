import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/map_detail/map_detail.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/core/widgets/redirect_button.dart';

class HeaderMenu extends ConsumerWidget {
  HeaderMenu({super.key});

  final List<String> imageAssets = [
    'assets/backgrounds/background_menu.png',
    'assets/menu-icons/mail.png',
    'assets/menu-icons/calendar.png',
    'assets/MINCE.png',
    'assets/menu-icons/steps.png',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/backgrounds/background_menu.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                70.verticalSpace,
                RedirectButton(
                  title: 'PÁTRAČKA',
                  imagePath: 'assets/menu-icons/loop.png',
                  imageWidth: 43,
                  imageHeight: 43,
                  right: 170,
                  bottom: 8,
                  screenToRoute: ScreenType.news,
                ),
                RedirectButton(
                  title: 'ROZPRÁVKY',
                  imagePath: 'assets/menu-icons/headphones.png',
                  imageWidth: 53,
                  imageHeight: 53,
                  right: 166,
                  bottom: 8,
                  webRoute: 'https://www.haravara.sk/pribehy/',
                ),
                RedirectButton(
                  title: 'TIPY NA VÝLETY',
                  imagePath: 'assets/menu-icons/batoh2.png',
                  imageWidth: 52,
                  imageHeight: 45,
                  right: 166,
                  bottom: 8,
                  webRoute: 'https://www.haravara.sk/vylety/',
                ),
                RedirectButton(
                  title: 'ATRAKCIE',
                  imagePath: 'assets/menu-icons/ship.png',
                  imageWidth: 51,
                  imageHeight: 54,
                  right: 166,
                  bottom: 8,
                  webRoute: 'https://www.haravara.sk/atrakcie',
                ),
                RedirectButton(
                  title: 'PODUJATIA',
                  imagePath: 'assets/menu-icons/calendar.png',
                  imageWidth: 45,
                  imageHeight: 45,
                  right: 166,
                  bottom: 8,
                  webRoute: 'https://www.haravara.sk/podujatia/',
                ),
                RedirectButton(
                  title: 'DETSKE ZONY',
                  imagePath: 'assets/menu-icons/steps2.png',
                  imageWidth: 70,
                  imageHeight: 55,
                  right: 154,
                  bottom: 8,
                  webRoute: 'https://www.haravara.sk/detske-zony/',
                ),
                RedirectButton(
                  title: 'OTÁZKY',
                  imagePath: 'assets/menu-icons/questions.png',
                  imageWidth: 50,
                  imageHeight: 50,
                  right: 166,
                  bottom: 8,
                  screenToRoute: ScreenType.summary,
                ),
              ],
            ),
          ),
          Positioned(
            top: 30.h,
            right: 30.w,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
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
            ),
          ),
        ],
      ),
      bottomSheet: Footer(
        height: 175,
        boxFit: BoxFit.fill,
        showMenu: false,
      ),
    );
  }

  handleLogout(WidgetRef ref, context) async {
    ref.read(loginNotifierProvider.notifier).logout();
    ref.read(collectedPlacesProvider.notifier).deleteAllPlaces();
    await DatabaseService().clearRichedPlaces();
    await DatabaseService().clearUserAllAvatarsFromDatabase();
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.auth));
  }
}

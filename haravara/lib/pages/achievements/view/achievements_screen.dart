import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/pages/profile/widgets/searcher_level.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import '../../../router/router.dart';
import '../../map_detail/map_detail.dart';
import '../widgets/widgets.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  var isInit = false;

  @override
  void initState() {
    super.initState();
    initPlaces();
  }

  initPlaces() async {
    final places = await DatabaseService().loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
    setState(() {
      isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/background_clouds.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8).r,
                child: Column(
                  children: [
                    const Header(showMenu: true),
                    10.verticalSpace,
                    Text(
                      'MoJE PEČIATKY',
                      style: GoogleFonts.titanOne(
                        shadows: [Shadow(color: Colors.black, blurRadius: 15)],
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 15.sp,
                      ),
                    ),
                    5.verticalSpace,
                    const SearcherLevel(color: Colors.black),
                    10.verticalSpace,
                    BuildSettings(),
                    5.verticalSpace,
                  ],
                ),
              ),
              Expanded(child: AchievementsList()),
              Footer(
                height: 40,
              ),
            ],
          ),
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(screenType: ScreenType.news,),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/pages/header_menu/header_menu.dart';
import 'package:haravara/pages/leaderBoard/leaderBoard.dart';
import 'package:haravara/pages/leaderBoardLevels/leaderBoardLevels.dart';
import 'package:haravara/pages/map_detail/map_detail.dart';
import 'package:haravara/pages/news/news.dart';
import 'package:haravara/pages/summary/summary.dart';

import '../pages/achievements/achiviements.dart';
import '../pages/auth/auth.dart';
import '../pages/auth_verification/auth_verification.dart';
import '../pages/compass/compass.dart';
import '../pages/conditions/conditions.dart';
import '../pages/map/map.dart';
import '../pages/prizes/prizes.dart';
import '../pages/profile/profile.dart';

enum ScreenType {
  menu,
  news,
  map,
  summary,
  auth,
  compass,
  achievements,
  code,
  detailMap,
  prizes,
  profile,
  podmienky,
  leaderBoard,
  leaderBoardLevels
}

Map screenTypeToWidget = <ScreenType, Widget>{
  ScreenType.menu: HeaderMenu(),
  ScreenType.news: const NewsScreen(),
  ScreenType.map: const MapScreen(),
  ScreenType.summary: const SummaryScreen(),
  ScreenType.compass: const Compass(),
  ScreenType.achievements: const AchievementsScreen(),
  ScreenType.auth: const AuthScreen(),
  ScreenType.code: const AuthVerificationScreen(),
  ScreenType.detailMap: const MapDetailScreen(),
  ScreenType.prizes: PrizesScreen(),
  ScreenType.profile: const ProfileScreen(),
  ScreenType.podmienky: const PodmienkyScreen(),
  ScreenType.leaderBoardLevels: const LeaderBoardLevelsScreen(),
};

class RouterNotifier extends StateNotifier<ScreenType> {
  RouterNotifier() : super(ScreenType.code);

  void changeScreen(ScreenType screenType) {
    state = screenType;
  }
}

final routerProvider = StateNotifierProvider<RouterNotifier, ScreenType>((ref) {
  return RouterNotifier();
});

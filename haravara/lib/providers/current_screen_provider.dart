import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/screens/achievements.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/screens/compass.dart';
import 'package:haravara/screens/map_screen.dart';
import 'package:haravara/screens/news_screen.dart';
import 'package:haravara/screens/summary_screen.dart';

enum ScreenType {
  news,
  map,
  summary,
  auth,
  compass,
  achievements,
}

Map screenTypeToWidget = <ScreenType, Widget>{
  ScreenType.news: const NewsScreen(),
  ScreenType.map: const MapScreen(),
  ScreenType.summary: const SummaryScreen(),
  ScreenType.compass: const Compass(),
  ScreenType.achievements: const AchievementsScreen(),
  ScreenType.auth: const AuthScreen(),
};

class CurrentScreenNotifier extends StateNotifier<ScreenType> {
  CurrentScreenNotifier() : super(ScreenType.news);

  void changeScreen(ScreenType screenType) {
    state = screenType;
  }
}

final currentScreenProvider =
    StateNotifierProvider<CurrentScreenNotifier, ScreenType>((ref) {
  return CurrentScreenNotifier();
});

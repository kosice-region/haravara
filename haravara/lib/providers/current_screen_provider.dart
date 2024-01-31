import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/screens/map_screen.dart';
import 'package:haravara/screens/news_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum ScreenType { news, map, summary, auth, compass, achievements }

@Riverpod(keepAlive: true)
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/screens/achievements.dart';
import 'package:haravara/screens/map_screen.dart';
import 'package:haravara/screens/news_screen.dart';
import 'package:haravara/screens/summary_screen.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ScreenRouter {
  routeToNextScreen<T extends Widget>(context, T screen) {
    Navigator.of(context).push(SwipeablePageRoute(
      canOnlySwipeFromEdge: true,
      builder: (BuildContext context) => screen,
    ));
  }

  routeToNextScreenWithoutAllowingRouteBack<T extends Widget>(
      context, T screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route route) => false);
  }

  Widget getScreenWidget(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.news:
        return NewsScreen();
      case ScreenType.map:
        return MapScreen();
      case ScreenType.summary:
        return SummaryScreen();
      case ScreenType.achievements:
        return AchievementsScreen();
      default:
        return NewsScreen(); // default screen
    }
  }
}

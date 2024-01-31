import 'package:flutter/material.dart';
import 'package:haravara/providers/current_screen_provider.dart';
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
    return screenTypeToWidget[screenType];
  }
}

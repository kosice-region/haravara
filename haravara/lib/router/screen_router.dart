import 'package:flutter/material.dart';
import 'package:haravara/router/router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ScreenRouter {
  routeToNextScreen<T extends Widget>(context, T screen) {

    Navigator.of(context).push(SwipeablePageRoute(
      canOnlySwipeFromEdge: true,
      fullscreenDialog: false,
      builder: (BuildContext context) => screen,
    ));
  }

  routeToNextScreenWithoutAnimation<T extends Widget>(context, T screen) {

    Navigator.of(context).push(SwipeablePageRoute(
      transitionDuration: const Duration(seconds: 0),
      reverseTransitionDuration: const Duration(seconds: 0),
      canOnlySwipeFromEdge: true,
      fullscreenDialog: false,
      builder: (BuildContext context) => screen,
    ));
  }

  routeToNextScreenWithoutAllowingRouteBack<T extends Widget>(
      context, T screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route route) => false);
  }

  void routeToNextScreenWithoutAllowingRouteBackWithoutAnimation<
      T extends Widget>(BuildContext context, T screen) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: const Duration(seconds: 0),
        reverseTransitionDuration: const Duration(seconds: 0),
      ),
      (Route route) => false,
    );
  }

  Widget getScreenWidget(ScreenType screenType) {
    return screenTypeToWidget[screenType];
  }
}

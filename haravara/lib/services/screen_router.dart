import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ScreenRouter {
  routeToNextScreen<T extends Widget>(context, T screen) {
    Navigator.of(context).push(SwipeablePageRoute(
      canOnlySwipeFromEdge: true,
      builder: (BuildContext context) => screen,
    ));
  }
}

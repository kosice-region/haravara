import 'package:flutter/material.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void routeToCodeScreen(BuildContext context) {
  if (!Navigator.of(context).mounted) return;
  ScreenRouter().routeToNextScreen(
    context,
    ScreenRouter().getScreenWidget(ScreenType.code),
  );
}

void routeToNewsScreen(BuildContext context) async {
  if (!Navigator.of(context).mounted) return;
  ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
      context, ScreenRouter().getScreenWidget(ScreenType.news));
}

int extractChildrenCount(String value) {
  final RegExp regex = RegExp(r'\d+');
  final Match? match = regex.firstMatch(value);
  if (match != null) {
    return int.parse(match.group(0)!);
  } else {
    return -1;
  }
}

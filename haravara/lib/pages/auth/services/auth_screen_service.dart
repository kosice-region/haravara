import 'package:flutter/material.dart';
import 'package:haravara/pages/admin/view/screens/admin_screen.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/core/services/database_service.dart';

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

void routeToAdminScreen(BuildContext context) {
  if (!Navigator.of(context).mounted) return;
  ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
    context,
    AdminScreen(),
  );
}

Future<void> routeToAppropriateScreen(
  BuildContext context,
  String email,
) async {
  if (!Navigator.of(context).mounted) return;

  final adminStatus = await DatabaseService().isAdmin(email);
  if (adminStatus) {
    routeToAdminScreen(context);
  } else {
    routeToNewsScreen(context);
  }
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

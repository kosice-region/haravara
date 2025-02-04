import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/init_service.dart';
import 'package:haravara/core/services/notification_controller.dart';
import 'package:haravara/pages/auth/services/auth_service.dart';

import 'pages/auth/auth.dart';
import 'pages/news/news.dart';
import 'pages/splash/splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HaravaraApp extends ConsumerStatefulWidget {
  const HaravaraApp({super.key});

  @override
  ConsumerState<HaravaraApp> createState() => _HaravaraAppState();
}

class _HaravaraAppState extends ConsumerState<HaravaraApp> {
  late Future _initFuture;
  bool _isInitCalled = false;

  @override
  void initState() {
    super.initState();
    _initFuture = Future.value();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    handleDynamicLinks();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitCalled) {
      _initFuture = Init.initialize(ref);
      _isInitCalled = true;
    }
    super.didChangeDependencies();
  }

  void handleDynamicLinks() async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      log('Deep link received: $deepLink');

      if (deepLink != null) {
        String? email = prefs.getString('email');
        log('Stored email: $email');
        if (email != null && email.isNotEmpty) {
          log('Attempting to sign in with email: $email');
          await AuthService().signInWithEmailLink(email, deepLink.toString());

          log('Calling handleRegistrationOrLogin');
          await AuthService().handleRegistrationOrLogin(email, ref, context);
        }
      }
    }).onError((error) {
      log('Dynamic link error: ${error.message}');
    });

    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink?.link != null) {
      final Uri deepLink = initialLink!.link;
      String? email = prefs.getString('email');
      log('Initial deep link received: $deepLink');
      if (email != null && email.isNotEmpty) {
        log('Stored email: $email');
        await AuthService().signInWithEmailLink(email, deepLink.toString());

        log('Calling handleRegistrationOrLogin');
        await AuthService().handleRegistrationOrLogin(email, ref, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(255, 516),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Haravara',
          home: FutureBuilder(
            future: _initFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ref.watch(loginNotifierProvider).isLoggedIn
                    ? const NewsScreen()
                    : const AuthScreen();
              } else {
                return const SplashScreen();
              }
            },
          ),
        );
      },
    );
  }
}

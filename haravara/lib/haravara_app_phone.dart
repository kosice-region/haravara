import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/init_service.dart';
import 'package:haravara/core/services/notification_controller.dart';

import 'pages/auth/auth.dart';
import 'pages/news/news.dart';
import 'pages/splash/splash.dart';

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
  }

  @override
  void didChangeDependencies() {
    if (!_isInitCalled) {
      _initFuture = Init.initialize(ref);
      _isInitCalled = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(255, 516),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
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

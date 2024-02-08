import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/screens/compass.dart';
import 'package:haravara/screens/splash_screen.dart';
import 'package:haravara/services/init_service.dart';
import 'package:haravara/services/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

var status = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        )
      ],
      debug: true);
  if (!await AwesomeNotifications().isNotificationAllowed()) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  status = prefs.getBool('isLoggedIn') ?? false;
  print(status);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const ProviderScope(child: ConsumerApp()));
  });
}

class ConsumerApp extends ConsumerStatefulWidget {
  const ConsumerApp({super.key});

  @override
  ConsumerState<ConsumerApp> createState() => _ConsumerAppState();
}

class _ConsumerAppState extends ConsumerState<ConsumerApp> {
  late Future _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = Init.initialize(ref);
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
                return const Compass(
                  targetLocation: LatLng(48.697295, 21.233280),
                );
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

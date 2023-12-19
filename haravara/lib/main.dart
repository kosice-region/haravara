import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/screens/google_map_second_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:haravara/services/auth_service.dart';
import 'package:haravara/services/notification_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      // Channel groups are only visual and are not required
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  get future => null;

  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    super.initState();
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
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Haravara',
          theme: ThemeData().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17, 177),
            ),
          ),
          home: const AuthScreen(),
          // home: StreamBuilder<bool>(
          //   stream: AuthService().findUserByPhoneId(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       // Handle waiting state
          //       return const CircularProgressIndicator();
          //     } else if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     } else if (snapshot.hasData) {
          //       // Handle data state
          //       bool userExists = snapshot.data!;
          //       if (userExists) {
          //         return GoogleMapSecondScreen();
          //       } else {
          //         return AuthScreen();
          //       }
          //     }
          //     return Container();
          //   },
          // ),
        );
      },
    );
  }
}

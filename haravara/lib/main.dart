import 'package:flutter/material.dart';
import 'package:haravara/screens/google_map_screen.dart';
import 'package:haravara/screens/google_map_second_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:haravara/services/notification_controller.dart';

void main() async {
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
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      // home: const GoogleMapScreen(),
      home: const GoogleMapSecondScreen(),
      // home: Scaffold(
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       AwesomeNotifications().createNotification(
      //         content: NotificationContent(
      //           id: 1,
      //           channelKey: 'basic_channel',
      //           title: '123',
      //           body: '321',
      //         ),
      //       );
      //     },
      //     child: const Icon(Icons.notification_add),
      //   ),
      // ),
    );
  }
}

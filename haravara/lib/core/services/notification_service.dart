import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  Future<void> sendNotification(String title, String body) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1, channelKey: 'basic_channel', title: title, body: body),
    );
  }
}

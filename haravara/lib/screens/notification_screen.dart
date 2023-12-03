import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key, this.showAppBar = true})
      : super(key: key);
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              leading: const BackButton(),
              title: const Text('Notifications'),
            )
          : null,
      body: ListView(
        children: [
          const NotificationTile(
            title: 'Dmitro Poslavskiy accepted your friend request!',
            subtitle: '13 Mei 2023 - now',
            actionText: 'See profile',
            actionColor: Colors.orange,
            path: 'images/Men2.png',
          ),
          const NotificationTile(
            title: 'You just found the T-System company.',
            subtitle: '13 Mei 2023 - 14:15',
            actionText: 'Total coins',
            actionColor: Colors.purple,
            path: 'images/T.png',
          ),
          FriendRequestTile(
            name: 'Vladislav Sakhnenko',
            date: '13 Apr 2022 - 14:15',
            onAccept: () {
              // Handle accept action
            },
            onDecline: () {
              // Handle decline action
            },
          ),
          // Add more notification tiles as needed
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final Color actionColor;
  final String path;
  const NotificationTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.actionColor,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(path),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: TextButton(
        onPressed: () {
          // Perform your action here
        },
        style: TextButton.styleFrom(
          foregroundColor: actionColor,
        ),
        child: Text(actionText),
      ),
    );
  }
}

class FriendRequestTile extends StatelessWidget {
  final String name;
  final String date;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FriendRequestTile({
    Key? key,
    required this.name,
    required this.date,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage:
            AssetImage('images/Men.png'), // Replace with your image path
      ),
      title: Text('$name wants to be your friend!'),
      subtitle: Text(date),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: onAccept,
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text('Accept'),
          ),
          TextButton(
            onPressed: onDecline,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}

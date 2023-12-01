import 'dart:ui';

import 'package:flutter/material.dart';

class ActivityTrackerScreen extends StatelessWidget {
  const ActivityTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatsBar(),
            SizedBox(height: 16),
            ActivityItem(
              activity: 'Java course',
              energyChange: -30,
              knowledgeChange: 50,
              color: Colors.purple,
            ),
            SizedBox(height: 16),
            ActivityItem(
              activity: 'Relax',
              energyChange: 40,
              knowledgeChange: 0,
              color: Color.fromARGB(255, 255, 226, 8),
            ),
            SizedBox(height: 16),
            ActivityItem(
              activity: 'Python course Basics',
              energyChange: -50,
              knowledgeChange: 50,
              color: Colors.purple,
            ),
            SizedBox(height: 16),
            ActivityItem(
              activity: 'LeetCode',
              energyChange: -30,
              knowledgeChange: 60,
              color: Colors.purple,
            ),
            SizedBox(height: 16),
            ActivityItem(
              activity: 'Parking Application Pet Project',
              energyChange: -20,
              knowledgeChange: 20,
              color: Colors.purple,
            ),
            SizedBox(height: 16),
            ActivityItem(
              activity: 'Vacation',
              energyChange: 40,
              knowledgeChange: 0,
              color: Color.fromARGB(255, 255, 226, 8),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              const Text('Energy: 100',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.grey[200],
                  color: Colors.green),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Text('Knowledge points: 0',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              LinearProgressIndicator(
                  value: 0.0,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue),
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String activity;
  final int energyChange;
  final int knowledgeChange;
  final Color color;

  const ActivityItem({
    Key? key,
    required this.activity,
    required this.energyChange,
    required this.knowledgeChange,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.star, color: color),
        title: Text(activity),
        subtitle: Text('Energy: $energyChange Knowledge: $knowledgeChange'),
        tileColor: color.withOpacity(0.1),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abilities'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hard skills',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SkillBar(
                  label: 'Backend skills', color: Colors.purple, progress: 0.8),
              SkillBar(
                  label: 'Frontend skills',
                  color: Colors.purple,
                  progress: 0.6),
              SkillBar(
                  label: 'Data analysis', color: Colors.purple, progress: 0.7),
              SkillBar(
                  label: 'Algorithmics', color: Colors.purple, progress: 0.9),
              SizedBox(height: 16),
              Text(
                'Soft skills',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SkillBar(
                  label: 'Communication', color: Colors.blue, progress: 0.9),
              SkillBar(
                  label: 'Problem solving', color: Colors.blue, progress: 0.75),
              SkillBar(
                  label: 'Teamworking', color: Colors.blue, progress: 0.85),
              SkillBar(label: 'Stamina', color: Colors.blue, progress: 0.65),
            ],
          ),
        ),
      ),
    );
  }
}

class SkillBar extends StatelessWidget {
  final String label;
  final Color color;
  final double progress;

  const SkillBar({
    Key? key,
    required this.label,
    required this.color,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: color.withOpacity(0.3),
            color: color,
          ),
        ],
      ),
    );
  }
}

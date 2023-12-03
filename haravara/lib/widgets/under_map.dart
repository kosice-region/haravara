import 'package:flutter/material.dart';

class UnderMap extends StatefulWidget {
  const UnderMap({super.key});

  @override
  State<UnderMap> createState() => _UnderMapState();
}

class _UnderMapState extends State<UnderMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add your button press logic here
                },
                child: const Center(
                  child: Row(
                    children: [
                      Icon(Icons
                          .find_replace_outlined), // Replace with your desired icon
                      SizedBox(
                          width: 8), // Add some space between icon and text
                      Text("Where To"), // Replace with your desired text
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

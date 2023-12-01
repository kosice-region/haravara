import 'package:flutter/material.dart';
import 'package:game_project/screens/info_detail.dart';

class InfoWiget extends StatelessWidget {
  const InfoWiget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            color: const Color.fromARGB(255, 255, 0, 144),
            child: const Text(
              'Deutsche Telekom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text('Information'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const InfoDetail()));
                    },
                  ),
                ),
                Container(
                  color:
                      Colors.white, // Set the background color for the button
                  child: ListTile(
                    title: const Text('Office'),
                    onTap: () {},
                  ),
                ),
                Container(
                  color:
                      Colors.white, // Set the background color for the button
                  child: ListTile(
                    title: const Text('Technologies we need'),
                    onTap: () {
                      // Handle the tap
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

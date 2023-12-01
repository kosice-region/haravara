import 'package:flutter/material.dart';
import 'package:game_project/screens/quiz/quiz.dart';
import 'package:google_fonts/google_fonts.dart';

class QueezScreen extends StatefulWidget {
  const QueezScreen(this.startQuiz, {super.key});

  final void Function() startQuiz;
  @override
  State<QueezScreen> createState() => _QueezScreenState();
}

class _QueezScreenState extends State<QueezScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 78, 13, 151),

        title: Text(
          'Level 1: Available companies',
          style: GoogleFonts.lato(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) => Quiz()));
              },
              icon: Image.asset('images/TS.png'),
            ),
          ),
        ],
      ),
    );
  }
}

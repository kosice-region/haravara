import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Popup extends StatelessWidget {
  final String title;
  final String content;

  const Popup({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.titanOne(),
      ),
      content: Text(
        content,
        style: GoogleFonts.titanOne(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Ok",
            style: GoogleFonts.titanOne(),
          ),
        ),
      ],
    );
  }
}
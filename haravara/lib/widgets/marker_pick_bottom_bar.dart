import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkerPickBottomBar extends StatefulWidget {
  const MarkerPickBottomBar(
      {super.key,
      required this.title,
      required this.body,
      required this.onPressed});

  final String title;
  final String body;
  final void Function() onPressed;

  @override
  State<MarkerPickBottomBar> createState() => _MarkerPickBottomBarState();
}

class _MarkerPickBottomBarState extends State<MarkerPickBottomBar> {
  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final baseHeight = MediaQuery.of(context).size.height * 0.16;
    final additionalHeight = MediaQuery.of(context).size.height * 0.05;
    const int titleLengthThreshold = 18;
    final bool isTwoLines = widget.title.length > titleLengthThreshold;
    final containerHeight =
        isTwoLines ? baseHeight + additionalHeight : baseHeight;
    return Column(
      children: [
        Center(
          child: Container(
            width: widthSize * 0.8,
            height: containerHeight * 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 254, 248, 248),
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27,
                      vertical: 3,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.titanOne(
                            color: Colors.amber,
                            fontSize: widthSize * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.body,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.titanOne(
                              color: const Color.fromARGB(255, 187, 137, 196),
                              fontSize: widthSize * 0.043,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 17, 114),
                        padding: EdgeInsets.symmetric(
                          vertical: containerHeight * 0.008,
                          horizontal: widthSize * 0.05,
                        ),
                      ),
                      onPressed: widget.onPressed,
                      child: Text(
                        'Select',
                        style: GoogleFonts.titanOne(
                            color: Colors.white,
                            fontSize: widthSize * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

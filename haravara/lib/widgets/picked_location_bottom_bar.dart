import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PickedLocationBottomBar extends StatefulWidget {
  const PickedLocationBottomBar({
    Key? key,
    required this.location,
    required this.onStop,
    this.distance,
  }) : super(key: key);

  final String location;
  final double? distance;
  final void Function() onStop;
  @override
  State<PickedLocationBottomBar> createState() =>
      _PickedLocationBottomBarState();
}

class _PickedLocationBottomBarState extends State<PickedLocationBottomBar> {
  bool isNearPoint = false;

  String getCurrentString(double distance) {
    if (distance > 25.0) {
      return 'You are in ${distance.toStringAsFixed(2)} meters';
    }
    if (distance <= 25) {
      isNearPoint = true;
      return 'You are here\n You got a new prize';
    }
    isNearPoint = true;
    return 'You are nearby';
  }

  @override
  Widget build(BuildContext context) {
    final heightSize = (MediaQuery.of(context).size.height);
    final widthSize = (MediaQuery.of(context).size.width);
    final style = GoogleFonts.titanOne(
        color: const Color.fromARGB(255, 189, 38, 169),
        fontSize: widthSize * 0.04,
        fontWeight: FontWeight.w300);
    return Column(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 255, 255, 255),
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
                          'HEY!',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.titanOne(
                            color: const Color.fromARGB(255, 189, 38, 169),
                            fontSize: widthSize * 0.09,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        if (widget.distance == null)
                          Text(
                            'Exploring location \n ${widget.location}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: style,
                          ),
                        if (widget.distance != null)
                          Text(
                            getCurrentString(widget.distance!),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: style,
                          ),
                        Text(
                          'CARRY ON!',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: GoogleFonts.titanOne(
                              color: const Color.fromARGB(255, 6, 38, 169),
                              fontSize: widthSize * 0.1,
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
                          vertical: heightSize * 0.008,
                          horizontal: widthSize * 0.05,
                        ),
                      ),
                      onPressed: widget.onStop,
                      child: Text(
                        isNearPoint ? 'Prize' : 'Cancel',
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

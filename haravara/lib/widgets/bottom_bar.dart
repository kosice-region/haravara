import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/location_place.dart';
import 'package:haravara/models/location_places.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.location,
    required this.onPressed,
  });

  final LocationPlace location;
  final void Function(LocationPlaces) onPressed;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final heightSize = (MediaQuery.of(context).size.height);
    final widthSize = (MediaQuery.of(context).size.width);
    return Column(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 254, 248, 248),
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        widget.location.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                          color: Colors.amber,
                          fontSize: widthSize * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.location.quantity.toString()} locations',
                        style: GoogleFonts.titanOne(
                            color: const Color.fromARGB(255, 187, 137, 196),
                            fontSize: widthSize * 0.043,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: widthSize * 0.01,
                      horizontal: heightSize * 0.02,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Image.asset(widget.location.images[0],
                              fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Image.asset(widget.location.images[1],
                              fit: BoxFit.cover),
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
                      onPressed: () =>
                          widget.onPressed(widget.location.locationPlaces),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:vibration/vibration.dart';

class CongratulationsDialog extends StatefulWidget {
  final String pickedPlaceName;

  const CongratulationsDialog({required this.pickedPlaceName, Key? key})
      : super(key: key);

  @override
  _CongratulationsDialogState createState() => _CongratulationsDialogState();
}

class _CongratulationsDialogState extends State<CongratulationsDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _triggerVibration();
    });
  }

  Future<void> _triggerVibration() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 500);
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight / 2.3;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: containerHeight,
            width: 224.w,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 140, 192, 225),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                12.verticalSpace,
                Text(
                  'GRATULUJEME!',
                  style: GoogleFonts.titanOne(
                      color: Colors.black, fontSize: 20.sp),
                ),
                12.verticalSpace,
                Text(
                  'Dosiahli ste',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.titanOne(
                    color: Colors.black,
                    fontSize: 15.sp,
                  ),
                ),
                5.verticalSpace,
                Text(
                  widget.pickedPlaceName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.titanOne(
                      color: Colors.black, fontSize: 15.sp),
                ),
                30.verticalSpace,
                Container(
                  width: 100.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 22, 102, 177),
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  child: TextButton(
                    child: Text(
                      'Získať pečiatku',
                      style: GoogleFonts.titanOne(
                        color: Colors.white,
                        fontSize: 15.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -150.h,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14159 / 2,
                blastDirectionality: BlastDirectionality.directional,
                maxBlastForce: 20,
                minBlastForce: 5,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.2,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                ],
                createParticlePath: drawStar,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (3.14159 / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final path = Path();
    final double radiansPerPoint = degToRad(360 / numberOfPoints);
    path.moveTo(halfWidth, 0);
    for (int i = 0; i < numberOfPoints; i++) {
      final double externalX =
          halfWidth + externalRadius * cos(degToRad(18) + radiansPerPoint * i);
      final double externalY =
          halfWidth + externalRadius * sin(degToRad(18) + radiansPerPoint * i);
      path.lineTo(externalX, externalY);
      final double internalX =
          halfWidth + internalRadius * cos(radiansPerPoint * (i + 0.5));
      final double internalY =
          halfWidth + internalRadius * sin(radiansPerPoint * (i + 0.5));
      path.lineTo(internalX, internalY);
    }
    path.close();
    return path;
  }
}

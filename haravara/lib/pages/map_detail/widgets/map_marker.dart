import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/services/event_bus.dart';

final eventBus = EventBus();

class MapMarker extends ConsumerWidget {
  const MapMarker({
    required this.placeId,
    required this.index,
    required this.isCollected,
    required this.isSelected,
    super.key,
  });

  final bool isCollected;
  final bool isSelected;
  final String placeId;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        eventBus.sendEvent(placeId);
      },
      child: Container(
        width: 95.w,
        height: 95.h,
        decoration: BoxDecoration(
          color: isCollected
              ? Color.fromARGB(255, 143, 190, 72)
              : Color.fromARGB(255, 229, 13, 0),
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 10.w,
                    blurRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            (index + 1).toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 32.dg,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

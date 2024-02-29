import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/services/event_bus.dart';

final eventBus = EventBus();

class MapMarker extends ConsumerWidget {
  const MapMarker({required this.placeId, required this.index, super.key});
  final String placeId;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        eventBus.sendEvent(placeId);
      },
      child: Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 229, 13, 0),
          borderRadius: BorderRadius.all(Radius.circular(38.r)),
        ),
        child: Text(
          (index + 1).toString(),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 25.dg,
              fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

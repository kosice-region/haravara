import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';

class SearcherLevel extends ConsumerWidget {
  final Color color;
  final bool shadow;

  const SearcherLevel(
      {super.key, this.color = Colors.white, this.shadow = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String levelOfSearcher =
        ref.watch(placesProvider.notifier).getLevelOfSearcher();

    return Text(
      levelOfSearcher,
      style: GoogleFonts.titanOne(
        fontSize: 13.sp,
        fontWeight: FontWeight.w300,
        color: color,
        shadows: shadow ? [Shadow(color: Colors.black, blurRadius: 15)] : [],
      ),
    );
  }
}

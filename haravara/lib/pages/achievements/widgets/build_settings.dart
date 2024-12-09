import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/achievements/widgets/widgets.dart';

class BuildSettings extends StatelessWidget {
  const BuildSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> sortItems = ['Získané', 'Nezískané'];
    final List<String> viewItems = ['Menej', 'Viac'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button(
          text: 'Sort',
          icon: Icons.sort_rounded,
          items: sortItems,
          isSort: true,
        ),
        20.horizontalSpace,
        Button(
          text: 'View',
          icon: Icons.view_compact,
          items: viewItems,
          isSort: false,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/achievements/providers/settings_provider.dart';
import 'package:haravara/pages/achievements/widgets/achievement.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';

class AchievementsList extends ConsumerStatefulWidget {
  const AchievementsList({super.key});

  @override
  ConsumerState<AchievementsList> createState() => _AchievementsListState();
}

class _AchievementsListState extends ConsumerState<AchievementsList> {
  @override
  Widget build(BuildContext context) {
    final selectedValueSort = ref.watch(settingsProvider).getCurrentValueSort();
    final selectedValueView = ref.watch(settingsProvider).getCurrentValueView();
    final places = ref
        .watch(placesProvider.notifier)
        .getSortedPlacesForward(selectedValueSort == 'Získané');
    return Expanded(
      child: GridView.count(
        crossAxisCount: selectedValueView == 'Menej' ? 2 : 3,
        childAspectRatio: 5 / (selectedValueView == 'Menej' ? 4.5.h : 5.5.h),
        children: [
          for (final place in places)
            Achievement(
              place: place,
              size: (selectedValueView == 'Menej'
                  ? ScreenSize.two
                  : ScreenSize.three),
            ),
        ],
      ),
    );
  }
}

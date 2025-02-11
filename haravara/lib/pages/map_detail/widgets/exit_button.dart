
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:haravara/pages/map_detail/providers/picked_place_provider.dart';

class ExitButton extends ConsumerWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Color.fromARGB(255, 226, 209, 71)),
      child: IconButton(
        icon: Icon(
          Icons.close,
          size: 10.dg,
          color: Colors.black,
        ),
        onPressed: () {
          ref.read(pickedPlaceProvider.notifier).resetPlace();
          ScreenRouter().routeToNextScreen(
              context, ScreenRouter().getScreenWidget(ScreenType.map));
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:haravara/core/widgets/redirect_button.dart';
import 'package:haravara/router/router.dart';

class RedirectButtons extends StatelessWidget {
  const RedirectButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RedirectButton(
          title: 'Moje\npečiatky',
          imagePath: 'assets/PECIATKA.png',
          imageWidth: 51,
          imageHeight: 57,
          right: 166,
          bottom: 0,
          screenToRoute: ScreenType.achievements,
        ),
        RedirectButton(
          title: 'Moje\nvýhry',
          imagePath: 'assets/menu-icons/horse.png',
          imageWidth: 73,
          imageHeight: 60,
          right: 152,
          bottom: 0,
          screenToRoute: ScreenType.prizes,
        ),
      ],
    );
  }
}

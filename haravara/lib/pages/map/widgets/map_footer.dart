import 'package:flutter/cupertino.dart';

class mapFooter extends StatelessWidget {
  const mapFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: Image.asset(
          'assets/backgrounds/background_dark_green.png',
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        child: Image.asset(
          'assets/peopleMapScreen.png',
        ),
      ),
    ]);
  }
}

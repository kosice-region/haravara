import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/router.dart';
import '../../../router/screen_router.dart';

class ReportIcon extends ConsumerWidget{
  const ReportIcon({super.key});


  @override
  Widget build(BuildContext context,WidgetRef ref){
    return  IconButton(
        onPressed: () {
          ref.read(routerProvider.notifier).changeScreen(ScreenType.bugreport);
          ScreenRouter().routeToNextScreen(
              context,
              ScreenRouter().getScreenWidget(ScreenType.bugreport)
          );
        },
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.yellow[600],
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    );
  }
}
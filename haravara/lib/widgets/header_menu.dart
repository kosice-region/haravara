import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/screens/map_screen.dart';
import 'package:haravara/services/screen_router.dart';
import 'package:page_transition/page_transition.dart';

class HeaderMenu extends StatefulWidget {
  const HeaderMenu({super.key});

  @override
  State<HeaderMenu> createState() => _HeaderMenuState();
}

class _HeaderMenuState extends State<HeaderMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                menuItem(context, 'NOVINKY', 'assets/menu-icons/mail.png',
                    const MapScreen()),
                menuItem(context, 'MAPA', 'assets/menu-icons/map.png',
                    const MapScreen()),
                menuItem(context, 'PECIATKY', 'assets/Icon.jpeg',
                    const AuthScreen()),
                menuItem(context, 'SUTAZE', 'assets/menu-icons/calendar.png',
                    const AuthScreen()),
                menuItem(context, 'ODHLASIT SA', 'assets/menu-icons/steps.png',
                    const AuthScreen()),
              ],
            ),
          ),
          Positioned(
            top: 90.h,
            right: 30.w,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(
      BuildContext context, String text, String path, Widget screen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w),
      child: FractionallySizedBox(
        widthFactor: 0.9.w,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
          onPressed: () {
            ScreenRouter().routeToNextScreen(context, screen);
          },
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.titanOne(
                    color: Colors.black,
                    fontSize: 23.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

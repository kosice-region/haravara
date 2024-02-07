import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/services/screen_router.dart';
import 'package:haravara/widgets/header_menu.dart';

class Header extends StatefulWidget {
  final bool showMenu;
  final Color backGroundColor;

  const Header({
    super.key,
    this.showMenu = true,
    this.backGroundColor = const Color.fromARGB(255, 91, 187, 75),
  });
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Padding(
        padding: const EdgeInsets.only(top: 27).r,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                25.horizontalSpace,
                Image(
                  image: const AssetImage('assets/logo-haravara.png'),
                  fit: BoxFit.cover,
                  width: 91.94.w,
                  height: 64.h,
                ),
                60.horizontalSpace,
                if (widget.showMenu)
                  GestureDetector(
                    onTap: () {
                      ScreenRouter().routeToNextScreen(
                          context,
                          HeaderMenu(
                            backGroundColor: widget.backGroundColor,
                          ));
                    },
                    child: Container(
                      height: 43.h,
                      width: 58.w,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)).r,
                        color: widget.backGroundColor,
                      ),
                      child: Column(
                        children: [
                          8.70.verticalSpace,
                          SizedBox(
                            height: 3.5.h,
                            width: 35.48.w,
                            child: const ColoredBox(
                              color: Colors.black,
                            ),
                          ),
                          8.33.verticalSpace,
                          SizedBox(
                            height: 3.5.h,
                            width: 35.48.w,
                            child: const ColoredBox(
                              color: Colors.black,
                            ),
                          ),
                          8.33.verticalSpace,
                          SizedBox(
                            height: 3.5.h,
                            width: 35.48.w,
                            child: const ColoredBox(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            )
          ],
        ));
  }
}

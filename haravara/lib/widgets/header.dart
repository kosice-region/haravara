import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/services/screen_router.dart';
import 'package:haravara/widgets/header_menu.dart';

class Header extends ConsumerStatefulWidget {
  final bool showMenu;
  final Color backGroundColor;
  final bool isCenter;
  final bool backButton;
  const Header({
    super.key,
    this.showMenu = true,
    this.isCenter = false,
    this.backButton = false,
    this.backGroundColor = const Color.fromARGB(255, 35, 146, 115),
  });
  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> {
  void openDetailMap() {
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.detailMap));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Padding(
        padding: const EdgeInsets.only(top: 27).r,
        child: widget.isCenter
            ? Center(
                child: Image(
                  image: const AssetImage('assets/logo-haravara.png'),
                  fit: BoxFit.cover,
                  width: 139.w,
                  height: 96.h,
                ),
              )
            : Column(
                children: [
                  if (widget.backButton) 18.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      25.horizontalSpace,
                      if (!widget.backButton)
                        Image(
                          image: const AssetImage('assets/logo-haravara.png'),
                          fit: BoxFit.cover,
                          width: 91.94.w,
                          height: 64.h,
                        ),
                      if (widget.backButton)
                        Container(
                          width: 80.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: widget.backGroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r))),
                          child: TextButton(
                            child: Text(
                              'SPÄŤ',
                              style: GoogleFonts.titanOne(
                                color: Colors.white,
                                fontSize: 15.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              openDetailMap();
                            },
                          ),
                        ),
                      60.horizontalSpace,
                      if (widget.showMenu)
                        GestureDetector(
                          onTap: () {
                            ScreenRouter()
                                .routeToNextScreen(context, const HeaderMenu());
                          },
                          child: Container(
                            height: 43.h,
                            width: 58.w,
                          ),
                        )
                    ],
                  )
                ],
              ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/news/view/news_screen.dart';
import 'package:haravara/pages/profile/widgets/widgets.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/router/router.dart';

import '../../../core/widgets/close_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          BackgroundImage(
            imagePath: 'assets/backgrounds/HARAVARA_profil.jpg',
          ),
          Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: 65.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Header(),
                    AvatarWidget(),
                    SizedBox(height: 5.h),
                    ActionButtons(),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 105.w,
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 91, 187, 75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 91, 187, 75),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                  ),
                                ),
                                child: Column(children: [
                                  ClipOval(
                                    child: Image.asset(
                                      'assets/PECIATKA.png',
                                      width: 80,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      'Moje\npečiatky',
                                      style: GoogleFonts.titanOne(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]),
                                onPressed: () => routeToNextScreen(
                                    context, ScreenType.achievements, ref),
                              )),
                          Container(
                            width: 105.w,
                            height: 160,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 91, 187, 75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                )),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 91, 187, 75),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)),
                                ),
                              ),
                              child: Column(children: [
                                ClipOval(
                                  child: Image.asset(
                                    'assets/menu-icons/horse.png',
                                    width: 90,
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    'Moje\nvýhry',
                                    style: GoogleFonts.titanOne(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ]),
                              onPressed: () => routeToNextScreen(
                                  context, ScreenType.prizes, ref),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ActionButtons2(),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(screenType: ScreenType.news,),
          ),
        ],
      ),
      bottomSheet: Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/pages/web_view/view/web_view_container.dart';
import 'package:haravara/router/screen_router.dart';

class RedirectButton extends ConsumerWidget {
  final String title;
  final String imagePath;
  final int imageWidth;
  final int imageHeight;
  final int right;
  final int bottom;
  ScreenType? screenToRoute;
  String? webRoute;

  RedirectButton({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    required this.right,
    required this.bottom,
    this.screenToRoute,
    this.webRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get screen width and height using ScreenUtil
    double deviceWidth = MediaQuery.of(context).size.width;

    // Adjust button width based on screen size
    double buttonWidth = deviceWidth * 0.7; // 70% of screen width for large screens
    if (deviceWidth < 600) {
      buttonWidth = deviceWidth * 0.6; // 60% for smaller screens
    }
    if (deviceWidth < 400) {
      buttonWidth = deviceWidth * 0.4; // 50% for very small screens
    }

    // Adjust image size based on screen size
    double imgWidth = imageWidth * 0.5; // 50% scale for image width
    double imgHeight = imageHeight * 0.5; // 50% scale for image height
    if (deviceWidth < 600) {
      imgWidth = imageWidth * 0.10;
      imgHeight = imageHeight * 0.10;
    }
    if (deviceWidth < 400) {
      imgWidth = imageWidth * 0.8;
      imgHeight = imageHeight * 0.8;
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: buttonWidth.w,  // Use responsive width
                height: 39.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 187, 75),
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)).h,
                    ),
                  ),
                  onPressed: () {
                    if (screenToRoute == null && webRoute != null) {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return WebViewContainer(url: webRoute!);
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset(0.0, 0.0);
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                      return;
                    }
                    var currentScreen = ref.watch(routerProvider);
                    if (currentScreen != screenToRoute) {
                      ref.read(routerProvider.notifier).changeScreen(screenToRoute!);
                      ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
                        context,
                        ScreenRouter().getScreenWidget(screenToRoute!),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      20.horizontalSpace,
                      Flexible(
                        flex: 3,
                        child: Text(
                          title,
                          style: GoogleFonts.titanOne(
                            color: Colors.black,
                            fontSize: 11.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: right.w,
          bottom: bottom.h,
          child: Image.asset(
            imagePath,
            width: imgWidth.w,  // Use responsive image width
            height: imgHeight.h,  // Use responsive image height
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

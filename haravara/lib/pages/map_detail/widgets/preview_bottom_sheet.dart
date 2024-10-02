import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/pages/map_detail/services/map_service.dart';
import 'package:haravara/pages/map_detail/services/screen_service.dart';
import 'package:haravara/pages/map_detail/widgets/local_button.dart';
import 'package:haravara/pages/web_view/view/web_view_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/router/router.dart';

class PreviewBottomSheet extends StatelessWidget {
  final BuildContext context;
  final Place pickedLocation;
  final Function routeToCompassScreen;

  const PreviewBottomSheet({
    required this.context,
    required this.pickedLocation,
    required this.routeToCompassScreen,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 15.sp);
    double padding = 20;
    double maxWidth = 224.w - padding * 1.4;
    String lengthOfDescription = pickedLocation.detail.description;
    String lengthOfTitle = pickedLocation.name;

    // Calculate the size of the text
    Size textSize = calculateTextSize(
      chooseBetterStringToCalculate(lengthOfTitle, lengthOfDescription),
      textStyle,
      maxWidth,
    );

    double containerHeight = textSize.height + padding * 7;

    return Container(
      height: containerHeight.h * 1.05,
      width: 255.w,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 236, 219),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                5.verticalSpace,
                Container(
                  width: 35.w,
                  height: 3.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                15.verticalSpace,
                Text(
                  pickedLocation.name,
                  style: GoogleFonts.titanOne(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 51, 206, 242),
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                GestureDetector(
                  onTap: () {
                    // Open the web view if the URL is valid
                    String url = pickedLocation.detail.description; // Assuming this is a URL
                    if (Uri.tryParse(url)?.hasScheme == true) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WebViewContainer(url: url),
                        ),
                      );
                    } else {
                      // Handle invalid URL case here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid URL')),
                      );
                    }
                  },
                  child: Text(
                    'Klikni pre informácie',
                    style: GoogleFonts.titanOne(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 33, 173, 4),
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      child: Image.file(
                        File(pickedLocation.placeImages!.location),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Column(
                  children: [
                    LocalButton(
                      name: 'Navigovať',
                      onPressed: () {
                        MapService().launchMap(context, pickedLocation);
                      },
                    ),
                    14.verticalSpace,
                    LocalButton(
                      name: 'Už som tu!',
                      onPressed: () {
                        routeToCompassScreen();
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
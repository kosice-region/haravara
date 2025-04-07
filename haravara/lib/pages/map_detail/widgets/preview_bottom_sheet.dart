import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/pages/map_detail/services/map_service.dart';
import 'package:haravara/pages/map_detail/widgets/local_button.dart';
import 'package:haravara/pages/web_view/view/web_view_container.dart';

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
    return Container(
      width: (MediaQuery.of(context).size.width * 0.7).clamp(255.w, 400.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 236, 219),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.verticalSpace,
                  ElevatedButton.icon(
                    onPressed: () {
                      String url = pickedLocation.detail.description;
                      if (Uri.tryParse(url)?.hasScheme == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WebViewContainer(url: url),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid URL')),
                        );
                      }
                    },
                    icon: Icon(Icons.info, color: Colors.white, size: 16.sp),
                    label: Text(
                      'Klikni pre informácie',
                      style: GoogleFonts.titanOne(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 33, 173, 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            (MediaQuery.of(context).size.width * 0.05).w),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width * 0.25)
                          .clamp(100.w, 150.w),
                      height: (MediaQuery.of(context).size.width * 0.25)
                          .clamp(100.h, 150.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        child: Image.file(
                          File(pickedLocation.placeImages!.location),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              child: const Center(child: Icon(Icons.error)),
                            );
                          },
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
                  ),
                ],
              ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

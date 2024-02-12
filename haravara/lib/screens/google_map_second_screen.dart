import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/event_bus.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/services/screen_router.dart';

class GoogleMapSecondScreen extends ConsumerStatefulWidget {
  const GoogleMapSecondScreen({
    required this.cameraTargetBounds,
    required this.cameraPosition,
    super.key,
  });
  final LatLngBounds cameraTargetBounds;
  final CameraPosition cameraPosition;

  @override
  ConsumerState<GoogleMapSecondScreen> createState() =>
      _GoogleMapSecondScreenState();
}

class _GoogleMapSecondScreenState extends ConsumerState<GoogleMapSecondScreen> {
  final eventBus = EventBus();
  LatLng? sourceLocation;
  final Completer<GoogleMapController> _controller = Completer();
  bool isMarkerPicking = true;
  bool isMarkerPicked = false;
  late Marker pickedMarker;
  late Place pickedLocation;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    eventBus.on<Marker>().listen((tappedMarker) {
      if (tappedMarker != null && mounted) {
        setState(() {
          pickedMarker = tappedMarker;
          pickedLocation = ref
              .watch(placesProvider)
              .where((place) => place.id == pickedMarker.markerId.value)
              .first;
          isMarkerPicked = true;
          print(pickedLocation.placeImages!.location);
        });
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 232.4.h,
              width: 255.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
              ),
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
                            color: const Color.fromARGB(255, 51, 206, 242)),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      Text(
                        pickedLocation.detail.description,
                        style: GoogleFonts.titanOne(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 33, 173, 4)),
                        textAlign: TextAlign.center,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
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
                          _LocalButton(
                              name: 'Navigovat\'',
                              onPressed: () {
                                MapService().lauchMap(context, pickedLocation);
                              }),
                          14.verticalSpace,
                          _LocalButton(
                              name: 'Pouzit\'',
                              onPressed: () {
                                routeToCompassScreen();
                              }),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    LatLngBounds bounds = LatLngBounds(
      southwest: const LatLng(48.0722569, 19.8085628),
      northeast: const LatLng(49.3252921, 23.3745267),
    );
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: 516.h,
          width: 255.w,
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(48.859101948221365, 21.244443170637833),
              zoom: 9,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            cameraTargetBounds: CameraTargetBounds(bounds),
            markers: ref.watch(markersProvider),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            padding: EdgeInsets.only(bottom: 170.h, right: 1.w, left: 10.w),
          ),
        ),
        Positioned(
          top: 50.h,
          left: 20.w,
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 20.dg,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ]),
    );
  }

  void getCurrentLocation() async {
    sourceLocation = await MapService().getCurrentLocation();
    setState(() {});
  }

  void routeToCompassScreen() {
    ref.read(currentScreenProvider.notifier).changeScreen(ScreenType.compass);
    String id = pickedLocation.id!;
    ref.read(pickedPlaceProvider.notifier).setNewPlace(id);
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.compass));
  }
}

class _LocalButton extends StatelessWidget {
  final String name;
  final void Function()? onPressed;
  final bool isCompass;

  const _LocalButton({
    super.key,
    required this.name,
    required this.onPressed,
    this.isCompass = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 27.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 7, 22, 121),
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
      ),
      child: GestureDetector(
        onTap: onPressed,
        onLongPress: onPressed,
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.titanOne(color: Colors.white, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}

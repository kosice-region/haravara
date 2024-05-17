import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/services/event_bus.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/services/screen_router.dart';
import 'package:haravara/widgets/map_marker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({super.key});

  @override
  ConsumerState<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  List<Offset> tapPositions = [];
  final TransformationController _controller = TransformationController();
  GlobalKey imageKey = GlobalKey();
  final eventBus = EventBus();
  bool isMarkerPicking = true;
  bool isMarkerPicked = false;
  late Place pickedLocation;

  @override
  void initState() {
    super.initState();
    initPlaces();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const double initialScale = 0.23;
      const Offset initialPosition = Offset(-2970.0, 10.0);
      _setInitialTransformation(initialScale, initialPosition);
    });

    eventBus.on<String>().listen((tappedMarker) {
      if (tappedMarker != null && mounted) {
        setState(() {
          pickedLocation = ref
              .watch(placesProvider)
              .where((place) => place.id == tappedMarker)
              .first;
          isMarkerPicked = true;
          // print(pickedLocation.placeImages!.location);
        });
        showModalBottomSheet(
          context: context,
          builder: (context) {
            TextStyle textStyle = TextStyle(fontSize: 15.sp);
            double padding = 20;
            double maxWidth = 224.w - padding * 1.4;
            String lengthOfDescription = pickedLocation.detail.description;
            String lengthOfTitle = pickedLocation.name;
            Size textSize = calculateTextSize(
                chooseBetterStringToCalculate(
                    lengthOfTitle, lengthOfDescription),
                textStyle,
                maxWidth);

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
                                  MapService()
                                      .launchMap(context, pickedLocation);
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
              ),
            );
          },
        );
      }
    });
  }

  initPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('${prefs.getStringList('collectedPlaces')}');
    final places = await DatabaseService().loadPlaces();
    ref.read(placesProvider.notifier).addPlaces(places);
  }

  void _setInitialTransformation(double scale, Offset position) {
    final Matrix4 matrix = Matrix4.identity()
      ..scale(scale)
      ..translate(position.dx, position.dy);
    _controller.value = matrix;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/places-map.jpg'), context);
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            key: imageKey,
            constrained: false,
            minScale: 0.01,
            maxScale: 1.1,
            scaleEnabled: true,
            panEnabled: true,
            transformationController: _controller,
            child: GestureDetector(
              onTapUp: (details) {
                setState(() {
                  print(
                      '${details.globalPosition.dx}, ${details.globalPosition.dy}');
                  tapPositions.add(Offset(
                      details.globalPosition.dx, details.globalPosition.dy));
                });
              },
              child: Consumer(
                builder: (context, ref, child) {
                  List<Place> places = ref.watch(placesProvider);
                  return Stack(children: [
                    Image.asset(
                      'assets/places-map.jpg',
                      fit: BoxFit.cover,
                    ),
                    // ...tapPositions.map((entry) {
                    //   return Positioned(
                    //     left: entry.dx.w,
                    //     top: entry.dy.h,
                    //     child: Container(
                    //       width: 85.w,
                    //       height: 85.h,
                    //       decoration: const BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.red,
                    //       ),
                    //     ),
                    //   );
                    // }),
                    ...places.asMap().entries.map((entry) {
                      int index = entry.key;
                      Place place = entry.value;
                      return Positioned(
                        left: place.geoData.primary.pixelCoordinates[0],
                        top: place.geoData.primary.pixelCoordinates[1],
                        child: MapMarker(
                          isCollected: place.isReached,
                          index: index,
                          placeId: place.id!,
                        ),
                      );
                    }),
                  ]);
                },
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 10.w,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Color.fromARGB(255, 226, 209, 71)),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 10.dg,
                  color: Colors.black,
                ),
                onPressed: () {
                  ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
                      context, ScreenRouter().getScreenWidget(ScreenType.map));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void routeToCompassScreen() {
    ref.read(currentScreenProvider.notifier).changeScreen(ScreenType.compass);
    String id = pickedLocation.id!;
    ref.read(pickedPlaceProvider.notifier).setNewPlace(id);
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.compass));
  }

  Size calculateTextSize(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    return textPainter.size;
  }

  String chooseBetterStringToCalculate(String firstText, String secondText) {
    if (firstText.length > secondText.length) {
      return firstText;
    }
    return secondText;
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

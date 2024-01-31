import 'dart:async';
import 'dart:io';

import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart' as Flutter;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/screens/google_map_second_screen.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:haravara/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:page_transition/page_transition.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  Set<Marker> _markers = <Marker>{};
  final Completer<GoogleMapController> _controller = Completer();
  LatLngBounds bounds = LatLngBounds(
    southwest: const LatLng(48.8004156, 20.2895598),
    northeast: const LatLng(48.91778829644273, 22.199326541275667),
  );
  late CameraPosition cameraPosition;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    return Scaffold(
      endDrawer: const HeaderMenu(),
      body: Padding(
        padding: const EdgeInsets.only(top: 12).h,
        child: Column(
          children: [
            const Header(),
            30.verticalSpace,
            Center(
              child: Text(
                'MAPA PEČIATOK',
                style: GoogleFonts.titanOne(
                    fontSize: 17.sp,
                    color: const Color.fromARGB(255, 1, 199, 67)),
              ),
            ),
            10.verticalSpace,
            Container(
              height: 110.h,
              width: 225.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(48.859101948221365, 21.244443170637833),
                    zoom: 8,
                  ),
                  markers: ref.watch(markersProvider),
                  cameraTargetBounds: CameraTargetBounds(bounds),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
            14.verticalSpace,
            if (Platform.isIOS)
              Column(
                children: [
                  CupertinoButton(
                      onPressed: () {
                        // places.isNotEmpty ? navigateToMap() : null;
                        navigateToMap();
                      },
                      color: const Color.fromARGB(255, 7, 179, 25),
                      // color: places.isNotEmpty
                      //     ? const Color.fromARGB(255, 7, 179, 25)
                      //     : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                      child: Text('Otvoriť mapu',
                          style: GoogleFonts.titanOne(color: Colors.white))),
                ],
              ),
            if (Platform.isAndroid)
              Column(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          const Color.fromARGB(255, 7, 179, 25)),
                    ),
                    onPressed: () {
                      // places.isNotEmpty ? navigateToMap() : null;
                      navigateToMap();
                    },
                    child: Text(
                      'Otvoriť mapu',
                      style: GoogleFonts.titanOne(color: Colors.white),
                    ),
                  ),
                  10.verticalSpace
                ],
              ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0.h,
                    child: const Footer(height: 175, boxFit: BoxFit.fill),
                  ),
                  Positioned(
                    bottom: 0.h,
                    right: 1.w,
                    left: 10.w,
                    child: Flutter.Image.asset(
                      'assets/peopleMapScreen.png',
                      height: 170.h,
                      width: 258.44.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  calculateBoundsAndInitialCameraPosition() async {
    var places = ref.watch(placesProvider);
    print(places);
    List<LatLng> latlng = [];
    for (var element in ref.watch(placesProvider)) {
      latlng.add(LatLng(element.geoData.primary.coordinates[0],
          element.geoData.primary.coordinates[1]));
    }
    final latLngBounds = MapService().findBounds(latlng);
    final cameraPosition = MapService().calculateInitialCameraPosition(latlng);
    this.cameraPosition = cameraPosition;
    bounds = latLngBounds;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(latLngBounds, 7),
    );
  }

  navigateToMap() {
    calculateBoundsAndInitialCameraPosition();
    if (Platform.isAndroid) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          duration: const Duration(seconds: 1),
          child: GoogleMapSecondScreen(
            cameraPosition: cameraPosition,
            cameraTargetBounds: bounds,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => GoogleMapSecondScreen(
            cameraPosition: cameraPosition,
            cameraTargetBounds: bounds,
          ),
        ),
      );
    }
  }
}

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
import 'package:haravara/providers/places_provider.dart';
import 'package:haravara/screens/google_map_second_screen.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:haravara/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  LatLng? sourceLocation;
  late List<Place> places = [];
  Set<Marker> _markers = <Marker>{};
  final Completer<GoogleMapController> _controller = Completer();
  LatLngBounds bounds = LatLngBounds(
    southwest: const LatLng(48.8004156, 20.2895598), // The southwestern corner
    northeast: const LatLng(
        48.91778829644273, 22.199326541275667), // The northeastern corner
  );
  late CameraPosition cameraPosition;

  @override
  void initState() {
    super.initState();
    getPlaces();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          const Header(showMenu: true),
          SizedBox(height: screenHeight * 0.129809.h),
          Center(
            child: Text(
              'MAPA PEČIATOK',
              style: GoogleFonts.titanOne(
                  fontSize: 30.sp,
                  color: const Color.fromARGB(255, 1, 199, 67)),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 200.h,
            width: 380.w,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: GestureDetector(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(48.859101948221365, 21.244443170637833),
                  zoom: 7.80,
                ),
                markers: _markers,
                cameraTargetBounds: CameraTargetBounds(bounds),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.0214.h),
          if (Platform.isIOS)
            Column(
              children: [
                CupertinoButton(
                    onPressed: () {
                      places.isNotEmpty ? showMapBottomSheet(context) : null;
                    },
                    color: places.isNotEmpty
                        ? const Color.fromARGB(255, 7, 179, 25)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    child: Text('Otvoriť mapu',
                        style: GoogleFonts.titanOne(color: Colors.white))),
                SizedBox(height: screenHeight * 0.022.h),
              ],
            ),
          if (Platform.isAndroid)
            Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        places.isNotEmpty
                            ? const Color.fromARGB(255, 7, 179, 25)
                            : Colors.grey),
                  ),
                  onPressed: () {
                    places.isNotEmpty ? showMapBottomSheet(context) : null;
                  },
                  child: Text(
                    'Otvoriť mapu',
                    style: GoogleFonts.titanOne(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          Expanded(
            child: Stack(
              children: [
                const Footer(),
                Positioned(
                  child: Flutter.Image.asset(
                    'assets/peopleMapScreen.png',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  calculateBoundsAndInitialCameraPosition() async {
    List<LatLng> latlng = [];
    for (var element in places) {
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

  getPlaces() async {
    sourceLocation = await MapService().getCurrentLocation();
    await DatabaseService().getAllPlaces(ref);
    places = ref.watch(PlacesProvider);
    _markers = await MapService().getMarkers(places);
    setState(() {});
    await calculateBoundsAndInitialCameraPosition();
  }

  // navigateToMap() {
  //   if (Platform.isAndroid) {
  //     Navigator.push(
  //       context,
  //       PageTransition(
  //         type: PageTransitionType.scale,
  //         alignment: Alignment.bottomCenter,
  //         duration: const Duration(seconds: 1),
  //         child: GoogleMapSecondScreen(
  //           places: places,
  //           markers: _markers,
  //           cameraPosition: cameraPosition,
  //           cameraTargetBounds: bounds,
  //         ),
  //       ),
  //     );
  //   } else {
  //     Navigator.push(
  //       context,
  //       CupertinoPageRoute(
  //         builder: (context) => GoogleMapSecondScreen(
  //           places: places,
  //           markers: _markers,
  //           cameraPosition: cameraPosition,
  //           cameraTargetBounds: bounds,
  //         ),
  //       ),
  //     );
  //   }
  // }

  void showMapBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Для полного открытия
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Начальный размер модального окна
          maxChildSize: 1.0, // Максимальный размер (весь экран)
          minChildSize: 0.3, // Минимальный размер
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                      child: GoogleMapSecondScreen(
                    places: places,
                    cameraPosition: cameraPosition,
                    cameraTargetBounds: bounds,
                    markers: _markers,
                  )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

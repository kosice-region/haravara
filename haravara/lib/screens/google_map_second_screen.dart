import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/data/geofence_list.dart';
import 'package:haravara/data/location_places_markers_data.dart';
import 'package:haravara/data/locations_places_data.dart';
import 'package:haravara/models/geofence_message.dart';
import 'package:haravara/models/location_place.dart';
import 'package:haravara/models/location_places.dart';
import 'package:haravara/models/place_marker.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/services/event_bus.dart';
import 'package:haravara/services/map_service.dart';
import 'package:haravara/services/notification_service.dart';
import 'package:haravara/widgets/bottom_bar.dart';
import 'package:haravara/widgets/marker_pick_bottom_bar.dart';
import 'package:haravara/widgets/picked_location_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/models/place.dart';

class GoogleMapSecondScreen extends ConsumerStatefulWidget {
  const GoogleMapSecondScreen({
    required this.cameraTargetBounds,
    required this.cameraPosition,
    Key? key,
  }) : super(key: key);
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(430, 932));
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: 932.h,
          width: 430.w,
          child: GoogleMap(
            initialCameraPosition: widget.cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            cameraTargetBounds: CameraTargetBounds(widget.cameraTargetBounds),
            markers: ref.watch(markersProvider),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            padding: EdgeInsets.only(bottom: 285.h, right: 1.w, left: 10.w),
          ),
        ),
        Positioned(
          top: 80.h,
          left: 20.w,
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 50.dg,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        if (isMarkerPicked)
          Positioned(
            top: 634.h,
            child: BottomBar(
              place: pickedLocation,
              onPressed: () {},
            ),
          ),
      ]),
    );
  }

  void getCurrentLocation() async {
    sourceLocation = await MapService().getCurrentLocation();
    setState(() {});
  }
}

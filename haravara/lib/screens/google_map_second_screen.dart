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
import 'package:haravara/providers/places_provider.dart';
import 'package:haravara/models/place.dart';

class GoogleMapSecondScreen extends ConsumerStatefulWidget {
  const GoogleMapSecondScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<GoogleMapSecondScreen> createState() =>
      _GoogleMapSecondScreenState();
}

class _GoogleMapSecondScreenState extends ConsumerState<GoogleMapSecondScreen> {
  LatLng? sourceLocation;
  late List<Place> places;
  Set<Marker> _markers = <Marker>{};
  final Completer<GoogleMapController> _controller = Completer();
  void getCurrentLocation() async {
    sourceLocation = await MapService().getCurrentLocation();
    print(sourceLocation);
    setState(() {});
  }

  void getPlaces() async {
    sourceLocation = await MapService().getCurrentLocation();
    await DatabaseService().getAllPlaces(ref);
    places = ref.watch(PlacesProvider);
    _markers = await MapService().getMarkers(places);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return sourceLocation == null && _markers.isEmpty
        ? const CircularProgressIndicator()
        : SizedBox(
            height: 932.h,
            width: 430.w,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: sourceLocation!,
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  northeast:
                      const LatLng(49.633475481391486, 22.746856634101785),
                  southwest:
                      const LatLng(47.742173546241645, 16.708306537445612),
                ),
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapToolbarEnabled: true,
              padding: EdgeInsets.only(bottom: 8.h, right: 8.w),
            ),
          );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geofence_service/models/geofence_radius_sort_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/data/geofence_list.dart';
import 'package:haravara/data/location_places_data.dart';
import 'package:haravara/models/location_places.dart';
import 'package:haravara/services/geofence_service.dart';
import 'package:haravara/services/google_map_service.dart';
import 'package:haravara/widgets/location_button.dart';
import 'package:haravara/widgets/under_map.dart';
import 'package:geofence_service/geofence_service.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng? sourceLocation;
  LatLng? pickedLocation;
  bool isLocationConfirmed = false;
  bool isPickingLocation = false;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  late GeofenceService _geofenceService;

  int _polylineIdCounter = 1;
  String? distance;
  static const IconData add_road =
      IconData(0xe059, fontFamily: 'MaterialIcons');

  void getCurrentLocation() async {
    sourceLocation = await GoogleMapService().getCurrentLocation();
    setState(() {});
  }

  void _initiliazeTracking(LatLng point) {
    setState(
      () {
        if (isPickingLocation == true) {
          isPickingLocation = false;
          _markers.clear();
          _polylines.clear();
          _polylineIdCounter = 1;
          distance = null;
          return;
        }
        isPickingLocation = true;
        _markers.add(
          Marker(
            markerId: const MarkerId('state'),
            position: point,
          ),
        );
      },
    );
  }

  void _confirmLocation() async {
    setState(() {
      isLocationConfirmed = true;
      pickedLocation = _markers.first.position;
    });
    var directions = await GoogleMapService().getDirections(
        LatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        LatLng(pickedLocation!.latitude, pickedLocation!.longitude));

    _goToPlace(
      CameraPosition(
          target: LatLng(directions['start_location']['lat'],
              directions['start_location']['lng'])),
      LatLngBounds(
          southwest: directions['bounds_sw'],
          northeast: directions['bounds_ne']),
      {},
    );
    _setPolyline(directions['polyline_decoded']);
    setState(() {
      distance = directions['distance'];
    });
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  void _changeMarker(LatLng point) {
    setState(() {
      _markers.clear();
      _markers
          .add(Marker(markerId: const MarkerId('changed'), position: point));
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _geofenceService = GeoFenceService().createGeofenceService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _geofenceService.addGeofenceStatusChangeListener(
          GeoFenceService().onGeofenceStatusChanged);
      _geofenceService
          .addLocationChangeListener(GeoFenceService().onLocationChanged);
      _geofenceService.addLocationServicesStatusChangeListener(
          GeoFenceService().onLocationServicesStatusChanged);
      _geofenceService
          .addActivityChangeListener(GeoFenceService().onActivityChanged);
      _geofenceService.addStreamErrorListener(GeoFenceService().onError);
      _geofenceService
          .start(geofenceList)
          .catchError(GeoFenceService().onError);
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourceLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: sourceLocation!, zoom: 16),
                    markers: {..._markers},
                    onTap: isPickingLocation
                        ? (value) {
                            _changeMarker(value);
                          }
                        : null,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    polylines: isPickingLocation ? _polylines : {},
                    myLocationEnabled: true,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: locationsPlacesData.map((locationPlace) {
                          return Column(
                            children: [
                              LocationButton(
                                locationPlace: locationPlace,
                                onPressed: (locationPlace) {
                                  _goToPlace(
                                    locationPlace.cameraPosition,
                                    locationPlace.bounds,
                                    locationPlace.markers,
                                  );
                                },
                              ),
                              const SizedBox(width: 5),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _goToPlace(CameraPosition cameraPosition,
      LatLngBounds latLngBounds, Set<Marker> makers) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(latLngBounds, 25),
    );

    setState(() {
      _markers = makers;
    });
  }
}

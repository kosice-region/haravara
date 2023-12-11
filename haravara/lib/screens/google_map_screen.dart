import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/data/geofence_list.dart';
import 'package:haravara/data/location_places_markers_data.dart';
import 'package:haravara/models/geofence_message.dart';
import 'package:haravara/services/event_bus.dart';
import 'package:haravara/services/google_map_service.dart';
import 'package:haravara/services/notification_service.dart';
import 'package:haravara/widgets/location_button.dart';

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
  Set<Marker> _markers = <Marker>{};
  GeofenceMessage? geofenceMessage;
  final _geofenceStreamController = StreamController<Geofence>();
  final _activityStreamController = StreamController<Activity>();
  final eventBus = EventBus();

  final _geofenceService = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: false,
      printDevLog: false,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    print('geofence: ${geofence.toJson()}');
    print('geofenceRadius: ${geofenceRadius.toJson()}');
    print('geofenceStatus: ${geofenceStatus.toString()}');
    _geofenceStreamController.sink.add(geofence);
    double? smallestEnterLength;
    GeofenceStatus? radiusStatus;
    for (var radius in geofence.radius) {
      print('Radius: ${radius.length} meters, Status: ${radius.status}');
      if (radius.status == GeofenceStatus.ENTER) {
        if (smallestEnterLength == null ||
            radius.length < smallestEnterLength) {
          smallestEnterLength = radius.length;
          radiusStatus = radius.toJson()['status'];
        }
      }
    }
    print('SMALLEST LENGTH WITH ENTRY STATUS ${smallestEnterLength}');
    print('STATUS ${radiusStatus}');

    setState(() {
      if (smallestEnterLength != null) {
        geofenceMessage = GeofenceMessage(
            geofenceLength: smallestEnterLength,
            geofenceRadius: geofenceRadius,
            geofenceStatus: radiusStatus!);
      } else {
        geofenceMessage = GeofenceMessage(
            geofenceLength: -1.0,
            geofenceRadius: geofenceRadius,
            geofenceStatus: radiusStatus!);
      }
    });
    NotificationService()
        .sendNotification('Haravara', smallestEnterLength.toString());
  }

  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

// This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {
    // print('location: ${location.toJson()}');
  }

// This function is to be called when a location services status change occurs
// since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

// This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }
    print('ErrorCode: $errorCode');
  }

  void getCurrentLocation() async {
    sourceLocation = await GoogleMapService().getCurrentLocation();
    print(sourceLocation);
    setState(() {});
  }

  void onConfirmLocation() async {
    setState(() {
      isPickingLocation = false;
      isLocationConfirmed = true;
      _markers = {
        Marker(
          markerId: const MarkerId('picked_location'),
          position: pickedLocation!,
          infoWindow: const InfoWindow(
            title: 'Test location',
            snippet: 'Test location',
          ),
        ),
      };
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          GoogleMapService()
              .boundsFromLatLngList([sourceLocation!, pickedLocation!]),
          25),
    );
    setState(() {
      _geofenceService.addGeofence(Geofence(
        id: 'picked_location',
        latitude: pickedLocation!.latitude,
        longitude: pickedLocation!.longitude,
        radius: [
          GeofenceRadius(id: 'radius_200m', length: 200),
          GeofenceRadius(id: 'radius_100m', length: 100),
          GeofenceRadius(id: 'radius_25m', length: 25),
          GeofenceRadius(id: 'radius_5m', length: 5),
        ],
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _geofenceService
          .addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      _geofenceService.addLocationChangeListener(_onLocationChanged);
      _geofenceService.addLocationServicesStatusChangeListener(
          _onLocationServicesStatusChanged);
      _geofenceService.addActivityChangeListener(_onActivityChanged);
      _geofenceService.addStreamErrorListener(_onError);
      _geofenceService.start(geofenceList).catchError(_onError);
    });
    eventBus.on<LatLng>().listen((event) {
      if (event != null) {
        setState(() {
          pickedLocation = event;
          isPickingLocation = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.80,
            child: sourceLocation == null
                ? const CircularProgressIndicator()
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: sourceLocation!,
                      zoom: 16,
                    ),
                    markers: {..._markers},
                    onTap: (value) {
                      getCurrentLocation();
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                  ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.20,
            child: Column(
              children: [
                if (!isLocationConfirmed)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: locationsPlacesData.map((locationPlace) {
                              return Row(
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
                                  const SizedBox(width: 10),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                if (isLocationConfirmed)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        onStopNavigation();
                      },
                      child: const Text('Do u want to stop navigation?'),
                    ),
                  ),
                if (isPickingLocation)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        onConfirmLocation();
                      },
                      child:
                          const Text('Do u wanna navigate to this position?'),
                    ),
                  ),
                if (geofenceMessage != null &&
                    geofenceMessage?.geofenceLength != -1.0)
                  Center(
                    child: Text(
                        'R_LNGTH ${geofenceMessage!.geofenceLength}, R_STATUS ${geofenceMessage!.geofenceStatus.toString()}',
                        maxLines: 3,
                        textAlign: TextAlign.center),
                  ),
                if (geofenceMessage != null &&
                    geofenceMessage?.geofenceLength == -1.0)
                  const Center(
                    child: Text('You have left from radius',
                        maxLines: 3, textAlign: TextAlign.center),
                  ),
                const SizedBox(height: 5),
              ],
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

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((controller) {
      controller.dispose();
    });
    _geofenceService
        .removeGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.removeLocationChangeListener(_onLocationChanged);
    _geofenceService.removeLocationServicesStatusChangeListener(
        _onLocationServicesStatusChanged);
    _geofenceService.removeActivityChangeListener(_onActivityChanged);
    _geofenceService.removeStreamErrorListener(_onError);
    _geofenceService.clearAllListeners();
    _geofenceService.stop();
  }

  void onStopNavigation() async {
    setState(() {
      isLocationConfirmed = false;
      geofenceMessage = null;
      _geofenceService.clearGeofenceList();
    });
  }
}

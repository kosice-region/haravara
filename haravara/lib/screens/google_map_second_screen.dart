import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/data/geofence_list.dart';
import 'package:haravara/data/location_places_markers_data.dart';
import 'package:haravara/data/locations_places_data.dart';
import 'package:haravara/models/geofence_message.dart';
import 'package:haravara/models/location_places.dart';
import 'package:haravara/services/event_bus.dart';
import 'package:haravara/services/google_map_service.dart';
import 'package:haravara/services/notification_service.dart';
import 'package:haravara/widgets/bottom_bar.dart';
import 'package:haravara/widgets/marker_pick_bottom_bar.dart';
import 'package:haravara/widgets/picked_location_bottom_bar.dart';

class GoogleMapSecondScreen extends StatefulWidget {
  const GoogleMapSecondScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleMapSecondScreen> createState() => _GoogleMapSecondScreenState();
}

class _GoogleMapSecondScreenState extends State<GoogleMapSecondScreen> {
  LatLng? sourceLocation;
  Marker? pickedMarker;
  bool isLocationConfirmed = false;
  bool isPickingLocation = true;
  bool isPickingMarker = false;
  int? lastPickedLocation;
  int initialPage = 0;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = <Marker>{};
  GeofenceMessage? geofenceMessage;
  double? smallestDistanceLength;

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
    double? smallestLength;
    GeofenceStatus? radiusStatus;
    for (var radius in geofence.radius) {
      print('Radius: ${radius.length} meters, Status: ${radius.status}');
      if (radius.status == GeofenceStatus.ENTER) {
        if (smallestLength == null || radius.length < smallestLength) {
          smallestLength = radius.length;
          radiusStatus = radius.toJson()['status'];
        }
      }
    }
    if (smallestLength == null) {
      for (var radius in geofence.radius) {
        print('Radius: ${radius.length} meters, Status: ${radius.status}');
        if (radius.status == GeofenceStatus.DWELL) {
          if (smallestLength == null || radius.length < smallestLength) {
            smallestLength = radius.length;
            radiusStatus = radius.toJson()['status'];
          }
        }
      }
    }

    print('SMALLEST LENGTH  ${smallestLength}');
    print('STATUS ${radiusStatus}');

    setState(() {
      if (smallestLength != null) {
        geofenceMessage = GeofenceMessage(
            geofenceLength: smallestLength,
            geofenceRadius: geofenceRadius,
            geofenceStatus: radiusStatus!);
        smallestDistanceLength = smallestLength;
      } else {
        geofenceMessage = GeofenceMessage(
            geofenceLength: -1.0,
            geofenceRadius: geofenceRadius,
            geofenceStatus: radiusStatus!);
        smallestDistanceLength = -1.0;
      }
    });
    NotificationService()
        .sendNotification('Haravara', smallestLength.toString());
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
      isPickingMarker = false;
      isPickingLocation = false;
      isLocationConfirmed = true;
      _markers = {
        Marker(
          markerId: const MarkerId('picked_location'),
          position: LatLng(pickedMarker!.position.latitude,
              pickedMarker!.position.longitude),
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
          GoogleMapService().boundsFromLatLngList([
            sourceLocation!,
            LatLng(pickedMarker!.position.latitude,
                pickedMarker!.position.longitude)
          ]),
          25),
    );
    setState(() {
      _geofenceService.addGeofence(Geofence(
        id: 'picked_location',
        latitude: pickedMarker!.position.latitude,
        longitude: pickedMarker!.position.longitude,
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
    eventBus.on<Marker>().listen((event) {
      if (event != null) {
        setState(() {
          pickedMarker = event;
          isPickingLocation = false;
          isPickingMarker = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourceLocation != null
          ? Stack(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9989,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: sourceLocation!,
                      zoom: 16,
                    ),
                    markers: {..._markers},
                    onTap: (value) {
                      setState(() {
                        isPickingMarker = false;
                        isPickingLocation = true;
                      });
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                    mapToolbarEnabled: true,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.33,
                    ),
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.66,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: isPickingLocation
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.41,
                            child: PageView.builder(
                              controller:
                                  PageController(initialPage: initialPage),
                              scrollDirection: Axis.horizontal,
                              itemCount: locationPlaces.length,
                              itemBuilder: (context, index) {
                                return BottomBar(
                                  location: locationPlaces[index],
                                  onPressed: (locationPlace) {
                                    initialPage = index;
                                    lastPickedLocation = index;
                                    _goToPlace(
                                      locationPlace.cameraPosition,
                                      locationPlace.bounds,
                                      locationPlace.markers,
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : isPickingMarker
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.41,
                                child: MarkerPickBottomBar(
                                  title: pickedMarker!.infoWindow.title!,
                                  body: pickedMarker!.infoWindow.snippet!,
                                  onPressed: onConfirmLocation,
                                ),
                              )
                            : isLocationConfirmed
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.41,
                                    child: PickedLocationBottomBar(
                                      distance: smallestDistanceLength,
                                      location: pickedMarker!.infoWindow.title!,
                                      onStop: onStopNavigation,
                                    ),
                                  )
                                : SizedBox()),
              ],
            )
          : const CircularProgressIndicator(),
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
    LocationPlaces locationPlace = locationsPlacesData[lastPickedLocation!];
    _goToPlace(
      locationPlace.cameraPosition,
      locationPlace.bounds,
      locationPlace.markers,
    );
    setState(() {
      isPickingLocation = true;
      isLocationConfirmed = false;
      isPickingMarker = false;
      geofenceMessage = null;
      _geofenceService.clearGeofenceList();
    });
  }
}

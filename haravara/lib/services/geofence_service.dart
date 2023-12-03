import 'dart:async';

import 'package:geofence_service/geofence_service.dart';
import 'package:haravara/models/geofence_message.dart';
import 'package:haravara/services/eventBus.dart';

class GeoFenceService {
  final _geofenceStreamController = StreamController<Geofence>();
  final _activityStreamController = StreamController<Activity>();
  final eventBus = EventBus();
  GeofenceService createGeofenceService() {
    return GeofenceService.instance.setup(
        interval: 5000,
        accuracy: 100,
        loiteringDelayMs: 60000,
        statusChangeDelayMs: 10000,
        useActivityRecognition: true,
        allowMockLocations: false,
        printDevLog: false,
        geofenceRadiusSortType: GeofenceRadiusSortType.DESC);
  }

  Future<void> onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    // print('geofence: ${geofence.toJson()}');
    // print('geofenceRadius: ${geofenceRadius.toJson()}');
    // print('geofenceStatus: ${geofenceStatus.toString()}');
    _geofenceStreamController.sink.add(geofence);
    sendData(GeofenceMessage(
        geofence: geofence,
        geofenceRadius: geofenceRadius,
        geofenceStatus: geofenceStatus));
  }

// This function is to be called when the activity has changed.
  void onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

// This function is to be called when the location has changed.
  void onLocationChanged(Location location) {
    // print('location: ${location.toJson()}');
  }

// This function is to be called when a location services status change occurs
// since the service was started.
  void onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

// This function is used to handle errors that occur in the service.
  void onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  void sendData(GeofenceMessage message) {
    print('data sent');
    eventBus.sendEvent(message);
  }
}

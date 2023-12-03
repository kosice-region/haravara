import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';

final geofenceList = <Geofence>[
  Geofence(
    id: 'place_1',
    latitude: 48.697316,
    longitude: 21.232661,
    radius: [
      GeofenceRadius(id: 'radius_25m', length: 25),
      GeofenceRadius(id: 'radius_100m', length: 100),
      GeofenceRadius(id: 'radius_200m', length: 200),
    ],
  ),
];

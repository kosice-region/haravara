import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';

final geofenceList = <Geofence>[
  Geofence(
    id: 'place_1',
    latitude: 48.697612,
    longitude: 21.233031,
    radius: [
      GeofenceRadius(id: 'radius_25m', length: 25),
      GeofenceRadius(id: 'radius_100m', length: 100),
      GeofenceRadius(id: 'radius_200m', length: 200),
    ],
  ),
  Geofence(
    id: 'place_2',
    latitude: 35.103422,
    longitude: 129.036023,
    radius: [
      GeofenceRadius(id: 'radius_100m', length: 100),
      GeofenceRadius(id: 'radius_25m', length: 25),
      GeofenceRadius(id: 'radius_250m', length: 250),
      GeofenceRadius(id: 'radius_200m', length: 200),
    ],
  ),
  Geofence(
    id: 'place_3',
    latitude: 35.104971,
    longitude: 129.034851,
    radius: [
      GeofenceRadius(id: 'radius_25m', length: 25),
      GeofenceRadius(id: 'radius_100m', length: 100),
      GeofenceRadius(id: 'radius_200m', length: 200),
    ],
  ),
];

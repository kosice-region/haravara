import 'package:geofence_service/geofence_service.dart';

class GeofenceMessage {
  final GeofenceRadius geofenceRadius;
  final GeofenceStatus geofenceStatus;
  final Geofence geofence;

  GeofenceMessage({
    required this.geofence,
    required this.geofenceRadius,
    required this.geofenceStatus,
  });
}

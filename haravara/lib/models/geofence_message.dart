import 'package:geofence_service/geofence_service.dart';

class GeofenceMessage {
  final GeofenceRadius geofenceRadius;
  final GeofenceStatus geofenceStatus;
  final double geofenceLength;

  GeofenceMessage({
    required this.geofenceLength,
    required this.geofenceRadius,
    required this.geofenceStatus,
  });
}

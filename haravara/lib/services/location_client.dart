import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationClient {
  final Location _location = Location();

  Stream<LatLng> get locationStream => _location.onLocationChanged
      .map((event) => LatLng(event.latitude!, event.longitude!));

  void init() async {
    Permission.locationAlways.request();
  }

  Future<bool> isServiceEnabled() async {
    return _location.serviceEnabled();
  }
}

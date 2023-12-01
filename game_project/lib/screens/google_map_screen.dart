import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_project/services/google_map_service.dart';
import 'package:game_project/widgets/under_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
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
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
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
          markerId: MarkerId('marker'),
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
      appBar: AppBar(
        title: const Text(
          'Track order',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: sourceLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _initiliazeTracking(LatLng(
                        sourceLocation!.latitude, sourceLocation!.longitude));
                  },
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(Icons.search_sharp),
                        SizedBox(width: 8),
                        Text("Set Location To Go"),
                      ],
                    ),
                  ),
                ),
                if (isPickingLocation)
                  ElevatedButton(
                    onPressed: () {
                      _confirmLocation();
                    },
                    child: Center(
                      child: Row(
                        children: [
                          Icon(distance == null ? Icons.done : add_road),
                          const SizedBox(width: 8),
                          Text(distance ?? "Confirm location to Go"),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: sourceLocation!, zoom: 16),
                    markers: isPickingLocation ? {..._markers} : {},
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
              ],
            ),
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }
}

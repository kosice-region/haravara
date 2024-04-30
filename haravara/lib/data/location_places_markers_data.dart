import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/location_places.dart';
import 'package:haravara/services/event_bus.dart';

final eventBus = EventBus();

var locationsPlacesData = [
  LocationPlaces(
    markers: {
      LocationPlaceMarker(
        markerID: 'kosice_place1',
        position: const LatLng(48.7204, 21.2575),
        infoWindow: const InfoWindow(
          title: 'St. Elisabeth Cathedral',
          snippet: 'Historic cathedral in Košice',
        ),
        onTapAction: (marker) {
          print(
              'Marker 1 tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
          eventBus.sendEvent(marker);
        },
      ),
      LocationPlaceMarker(
        markerID: 'kosice_place2',
        position: const LatLng(48.7132, 21.2653),
        infoWindow: const InfoWindow(
          title: 'Košice State Theater',
          snippet: 'Cultural landmark in Košice',
        ),
        onTapAction: (marker) {
          print(
              'Marker 2 tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
          eventBus.sendEvent(marker);
        },
      ),
      LocationPlaceMarker(
        markerID: 'kosice_place3',
        position: const LatLng(48.69730512001355, 21.232595643832145),
        infoWindow: const InfoWindow(
          title: 'Košice Jedlikova 9',
          snippet: 'Accommodation',
        ),
        onTapAction: (marker) {
          print(
              'Marker 3 tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
          eventBus.sendEvent(marker);
        },
      ),
      LocationPlaceMarker(
        markerID: 'kosice_place4',
        position: const LatLng(48.71679125194989, 21.25050390811236),
        infoWindow: const InfoWindow(
          title: 'Kosice Business Centre',
          snippet: 'InfoBip',
        ),
        onTapAction: (marker) {
          print(
              'Marker 4 tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
          eventBus.sendEvent(marker);
        },
      ),
    },
    locationName: 'Košice, Slovakia',
    bounds: LatLngBounds(
      southwest: const LatLng(48.7000, 21.2400),
      northeast: const LatLng(48.7300, 21.2800),
    ),
    cameraPosition: const CameraPosition(
      target: LatLng(48.7167, 21.2617),
      zoom: 15.0,
    ),
  ),
  LocationPlaces(
    markers: {
      LocationPlaceMarker(
        markerID: 'bratislava_castle',
        position: const LatLng(
            48.1427, 17.0997), // Approximate location of Bratislava Castle
        infoWindow: const InfoWindow(
          title: 'Bratislava Castle',
          snippet: 'Iconic castle overlooking the Danube',
        ),
        onTapAction: (marker) {
          print(
              'Bratislava Castle marker tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
          eventBus.sendEvent(marker);
        },
      ),
    },
    locationName: 'Bratislava Castle, Slovakia',
    bounds: LatLngBounds(
      southwest: const LatLng(48.1350, 17.0900),
      northeast: const LatLng(48.1500, 17.1100),
    ),
    cameraPosition: const CameraPosition(
      target: LatLng(48.1427, 17.0997),
      zoom: 15.0,
    ),
  ),
  LocationPlaces(
    markers: {
      LocationPlaceMarker(
        markerID: 'slovakia_place1',
        position: const LatLng(48.1414, 17.1169),
        infoWindow: const InfoWindow(
          title: 'Bratislava Castle',
          snippet: 'Historic castle in Bratislava',
        ),
        onTapAction: (marker) {
          print(
              'Marker 1 in Slovakia tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
        },
      ),
      LocationPlaceMarker(
        markerID: 'slovakia_place2',
        position: const LatLng(49.2992, 19.9496),
        infoWindow: const InfoWindow(
          title: 'Tatra Mountains',
          snippet: 'Slovakia\'s beautiful mountain range',
        ),
        onTapAction: (marker) {
          print(
              'Marker 2 in Slovakia tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
        },
      ),
      LocationPlaceMarker(
        markerID: 'slovakia_place3',
        position: const LatLng(48.8543, 18.0884),
        infoWindow: const InfoWindow(
          title: 'Bojnice Castle',
          snippet: 'Romantic castle in Bojnice',
        ),
        onTapAction: (marker) {
          print(
              'Marker 3 in Slovakiatapped at ${marker.position.latitude}, ${marker.position.longitude}!');
        },
      ),
      LocationPlaceMarker(
        markerID: 'slovakia_place4',
        position: const LatLng(48.5880, 19.6083),
        infoWindow: const InfoWindow(
          title: 'Dobsinska Ice Cave',
          snippet: 'UNESCO World Heritage site',
        ),
        onTapAction: (marker) {
          print(
              'Marker 4 in Slovakia tapped at ${marker.position.latitude}, ${marker.position.longitude}!');
        },
      ),
    },
    locationName: 'Places in Slovakia',
    bounds: LatLngBounds(
      southwest: const LatLng(47.5, 16.8),
      northeast: const LatLng(49.6, 22.6),
    ),
    cameraPosition: const CameraPosition(
      target: LatLng(48.5, 18.5),
      zoom: 7.0,
    ),
  ),
];

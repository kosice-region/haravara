import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/location_places.dart';

var locationsPlacesData = [
  LocationPlaces(
    markers: {
      const Marker(
        markerId: MarkerId('kosice_place1'),
        position: LatLng(48.7204, 21.2575),
        infoWindow: InfoWindow(
            title: 'St. Elisabeth Cathedral',
            snippet: 'Historic cathedral in Košice'),
      ),
      const Marker(
        markerId: MarkerId('kosice_place2'),
        position: LatLng(48.7132, 21.2653),
        infoWindow: InfoWindow(
            title: 'Košice State Theater',
            snippet: 'Cultural landmark in Košice'),
      ),
    },
    locationName: 'Košice, Slovakia',
    bounds: LatLngBounds(
      southwest: const LatLng(48.7000, 21.2400),
      northeast: const LatLng(48.7300, 21.2800),
    ),
    cameraPosition: const CameraPosition(
      target:
          LatLng(48.7167, 21.2617), // Set the initial camera target for Košice
      zoom: 15.0, // Set the initial zoom level for Košice
    ),
  ),
  LocationPlaces(
    markers: {
      const Marker(
        markerId: MarkerId('slovakia_place1'),
        position: LatLng(48.1414, 17.1169),
        infoWindow: InfoWindow(
            title: 'Bratislava Castle',
            snippet: 'Historic castle in Bratislava'),
      ),
      const Marker(
        markerId: MarkerId('slovakia_place2'),
        position: LatLng(49.2992, 19.9496),
        infoWindow: InfoWindow(
            title: 'Tatra Mountains',
            snippet: 'Slovakia\'s beautiful mountain range'),
      ),
      const Marker(
        markerId: MarkerId('slovakia_place3'),
        position: LatLng(48.8543, 18.0884),
        infoWindow: InfoWindow(
            title: 'Bojnice Castle', snippet: 'Romantic castle in Bojnice'),
      ),
      const Marker(
        markerId: MarkerId('slovakia_place4'),
        position: LatLng(48.5880, 19.6083),
        infoWindow: InfoWindow(
            title: 'Dobsinska Ice Cave', snippet: 'UNESCO World Heritage site'),
      ),
    },
    locationName: 'Interesting Places in Slovakia',
    bounds: LatLngBounds(
      southwest: const LatLng(47.5, 16.8),
      northeast: const LatLng(49.6, 22.6),
    ),
    cameraPosition: const CameraPosition(
      target: LatLng(48.5, 18.5), // Set the initial camera target for Slovakia
      zoom: 7.0, // Set the initial zoom level for Slovakia
    ),
  ),
  LocationPlaces(
    markers: {
      const Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(37.7749, -122.4194),
        infoWindow: InfoWindow(title: 'Marker 1', snippet: 'Sample marker 1'),
      ),
      const Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(37.6849, -122.4194),
        infoWindow: InfoWindow(title: 'Marker 2', snippet: 'Sample marker 2'),
      ),
    },
    locationName: 'San Francisco, CA',
    bounds: LatLngBounds(
      southwest: const LatLng(37.6, -122.6),
      northeast: const LatLng(37.9, -122.2),
    ),
    cameraPosition: const CameraPosition(
      target: LatLng(37.7749, -122.4194), // Set the initial camera target
      zoom: 12.0, // Set the initial zoom level
    ),
  ),
  LocationPlaces(
    markers: {
      const Marker(
        markerId: MarkerId('marker3'),
        position: LatLng(40.7128, -74.0060),
        infoWindow: InfoWindow(title: 'Marker 3', snippet: 'Sample marker 3'),
      ),
      const Marker(
        markerId: MarkerId('marker4'),
        position: LatLng(
            40.7128, -74.1000), // Adjust the coordinates to position it farther
        infoWindow: InfoWindow(title: 'Marker 4', snippet: 'Sample marker 4'),
      ),
    },
    locationName: 'New York, NY',
    bounds: LatLngBounds(
      southwest: const LatLng(40.4774, -74.2591),
      northeast: const LatLng(40.9176, -73.7004),
    ),
    cameraPosition: const CameraPosition(
      target: LatLng(40.7128, -74.0060), // Set the initial camera target
      zoom: 10.0, // Set the initial zoom level
    ),
  ),
  LocationPlaces(
    markers: {
      const Marker(
        markerId: MarkerId('marker5'),
        position: LatLng(34.0522, -118.2437),
        infoWindow: InfoWindow(title: 'Marker 5', snippet: 'Sample marker 5'),
      ),
      const Marker(
        markerId: MarkerId('marker6'),
        position:
            LatLng(34.0522, -118.2847), // Adjusted coordinates for separation
        infoWindow: InfoWindow(title: 'Marker 6', snippet: 'Sample marker 6'),
      ),
    },
    locationName: 'Los Angeles, CA',
    bounds: LatLngBounds(
      southwest: const LatLng(33.4774, -118.2591),
      northeast: const LatLng(34.9176, -117.7004),
    ),
    cameraPosition: const CameraPosition(
      target: LatLng(34.0522, -118.2437), // Set the initial camera target
      zoom: 10.0, // Set the initial zoom level
    ),
  ),
];

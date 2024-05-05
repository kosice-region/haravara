import 'package:haravara/data/location_places_markers_data.dart';
import 'package:haravara/models/location_place.dart';

var locationPlaces = [
  LocationPlace(
    title: 'Kosice',
    quantity: 5,
    images: ['assets/KosiceFirst.jpeg', 'assets/KosiceSecond.jpeg'],
    locationPlaces: locationsPlacesData[0],
  ),
  LocationPlace(
    title: 'Bratislava Castle',
    quantity: 3,
    images: ['assets/HradFirst.jpeg', 'assets/HradSecond.jpeg'],
    locationPlaces: locationsPlacesData[1],
  ),
];

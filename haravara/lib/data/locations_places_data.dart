import 'package:haravara/data/location_places_markers_data.dart';
import 'package:haravara/models/location_place.dart';

var locationPlaces = [
  LocationPlace(
    title: 'Kosice',
    quantity: 5,
    images: ['images/KosiceFirst.jpeg', 'images/KosiceSecond.jpeg'],
    locationPlaces: locationsPlacesData[0],
  ),
  LocationPlace(
    title: 'Bratislava Castle',
    quantity: 3,
    images: ['images/HradFirst.jpeg', 'images/HradSecond.jpeg'],
    locationPlaces: locationsPlacesData[1],
  ),
];

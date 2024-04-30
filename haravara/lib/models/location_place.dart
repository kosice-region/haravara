import 'package:haravara/models/location_places.dart';

class LocationPlace {
  final String title;
  final int quantity;
  final List<String> images;
  final LocationPlaces locationPlaces;

  LocationPlace(
      {required this.title,
      required this.quantity,
      required this.images,
      required this.locationPlaces});
}

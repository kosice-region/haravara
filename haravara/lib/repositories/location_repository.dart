import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:haravara/models/place.dart';
import 'package:uuid/parsing.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference placesRef = FirebaseDatabase.instance.ref('locations');
DatabaseReference imagesToPlacesRef = FirebaseDatabase.instance.ref('images');

class LocationRepository {
  final dio = Dio();

  Future<List<Place>> getAllPlaces() async {
    DataSnapshot placesSnapshot = await placesRef.get();
    DataSnapshot imagesSnapshot = await imagesToPlacesRef.get();
    final placesJson = decodeJsonFromSnapshot(placesSnapshot);
    final imagesJson = decodeJsonFromSnapshot(imagesSnapshot);

    List<Place> places = [];
    placesJson.forEach((key, value) {
      try {
        Map<String, dynamic> placeMap = value as Map<String, dynamic>;
        Map<String, dynamic>? imageMap =
            imagesJson[key] as Map<String, dynamic>?;

        PlaceImageFromDB imageFromDB =
            PlaceImageFromDB.fromJson(imageMap!).copyWith(placeId: key);

        Place place = Place.fromJson(placeMap)
            .copyWith(id: key, placeImages: imageFromDB);
        places.add(place);
      } catch (e) {
        print('Error parsing place data for key $key: $e');
      }
    });
    return places;
  }

  static Map<String, dynamic> decodeJsonFromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> dataFromSnapshot =
        snapshot.value as Map<dynamic, dynamic>;
    final jsonString = json.encode(dataFromSnapshot);
    final jsonToReturn = json.decode(jsonString) as Map<String, dynamic>;
    return jsonToReturn;
  }
}

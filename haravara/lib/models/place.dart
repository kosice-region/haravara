import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed
class Place with _$Place {
  const factory Place({
    String? id,
    required bool active,
    required int created,
    required Detail detail,
    required GeoData geoData,
    required String name,
    required int updated,
    PlaceImageFromDB? placeImages,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

@freezed
class Detail with _$Detail {
  const factory Detail({
    required String description,
  }) = _Detail;

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
}

@freezed
class GeoData with _$GeoData {
  const factory GeoData({
    required Primary primary,
  }) = _GeoData;

  factory GeoData.fromJson(Map<String, dynamic> json) =>
      _$GeoDataFromJson(json);
}

@freezed
class Primary with _$Primary {
  const factory Primary({
    required List<double> coordinates,
    required Fence fence,
  }) = _Primary;

  factory Primary.fromJson(Map<String, dynamic> json) =>
      _$PrimaryFromJson(json);
}

@freezed
class Fence with _$Fence {
  const factory Fence({
    required int radius,
  }) = _Fence;

  factory Fence.fromJson(Map<String, dynamic> json) => _$FenceFromJson(json);
}

@freezed
class PlaceImageFromDB with _$PlaceImageFromDB {
  const factory PlaceImageFromDB({
    String? placeId,
    required String location,
    required String stamp,
  }) = _PlaceImageFromDB;

  factory PlaceImageFromDB.fromJson(Map<String, dynamic> json) =>
      _$PlaceImageFromDBFromJson(json);
}

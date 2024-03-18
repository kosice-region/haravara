// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      id: json['id'] as String?,
      active: json['active'] as bool,
      created: json['created'] as int,
      detail: Detail.fromJson(json['detail'] as Map<String, dynamic>),
      geoData: GeoData.fromJson(json['geoData'] as Map<String, dynamic>),
      name: json['name'] as String,
      updated: json['updated'] as int,
      isReached: json['isReached'] ?? false,
      placeImages: json['placeImages'] == null
          ? null
          : PlaceImageFromDB.fromJson(
              json['placeImages'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'created': instance.created,
      'detail': instance.detail,
      'geoData': instance.geoData,
      'name': instance.name,
      'updated': instance.updated,
      'isReached': instance.isReached,
      'placeImages': instance.placeImages,
    };

_$DetailImpl _$$DetailImplFromJson(Map<String, dynamic> json) => _$DetailImpl(
      description: json['description'] as String,
    );

Map<String, dynamic> _$$DetailImplToJson(_$DetailImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
    };

_$GeoDataImpl _$$GeoDataImplFromJson(Map<String, dynamic> json) =>
    _$GeoDataImpl(
      primary: Primary.fromJson(json['primary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GeoDataImplToJson(_$GeoDataImpl instance) =>
    <String, dynamic>{
      'primary': instance.primary,
    };

_$PrimaryImpl _$$PrimaryImplFromJson(Map<String, dynamic> json) =>
    _$PrimaryImpl(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      fence: Fence.fromJson(json['fence'] as Map<String, dynamic>),
      pixelCoordinates: (json['pixelCoordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$PrimaryImplToJson(_$PrimaryImpl instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'fence': instance.fence,
      'pixelCoordinates': instance.pixelCoordinates,
    };

_$FenceImpl _$$FenceImplFromJson(Map<String, dynamic> json) => _$FenceImpl(
      radius: json['radius'] as int,
    );

Map<String, dynamic> _$$FenceImplToJson(_$FenceImpl instance) =>
    <String, dynamic>{
      'radius': instance.radius,
    };

_$PlaceImageFromDBImpl _$$PlaceImageFromDBImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaceImageFromDBImpl(
      placeId: json['placeId'] as String?,
      location: json['location'] as String,
      stamp: json['stamp'] as String,
    );

Map<String, dynamic> _$$PlaceImageFromDBImplToJson(
        _$PlaceImageFromDBImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'location': instance.location,
      'stamp': instance.stamp,
    };

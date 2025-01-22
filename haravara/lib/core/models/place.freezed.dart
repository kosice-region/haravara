// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return _Place.fromJson(json);
}

/// @nodoc
mixin _$Place {
  String? get id => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  int get created => throw _privateConstructorUsedError;
  Detail get detail => throw _privateConstructorUsedError;
  GeoData get geoData => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get updated => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  dynamic get isReached => throw _privateConstructorUsedError;
  PlaceImageFromDB? get placeImages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceCopyWith<Place> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceCopyWith<$Res> {
  factory $PlaceCopyWith(Place value, $Res Function(Place) then) =
      _$PlaceCopyWithImpl<$Res, Place>;
  @useResult
  $Res call(
      {String? id,
      bool active,
      int created,
      Detail detail,
      GeoData geoData,
      String name,
      int updated,
      int order,
      dynamic isReached,
      PlaceImageFromDB? placeImages});

  $DetailCopyWith<$Res> get detail;
  $GeoDataCopyWith<$Res> get geoData;
  $PlaceImageFromDBCopyWith<$Res>? get placeImages;
}

/// @nodoc
class _$PlaceCopyWithImpl<$Res, $Val extends Place>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? active = null,
    Object? created = null,
    Object? detail = null,
    Object? geoData = null,
    Object? name = null,
    Object? updated = null,
    Object? order = null,
    Object? isReached = freezed,
    Object? placeImages = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as Detail,
      geoData: null == geoData
          ? _value.geoData
          : geoData // ignore: cast_nullable_to_non_nullable
              as GeoData,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isReached: freezed == isReached
          ? _value.isReached
          : isReached // ignore: cast_nullable_to_non_nullable
              as dynamic,
      placeImages: freezed == placeImages
          ? _value.placeImages
          : placeImages // ignore: cast_nullable_to_non_nullable
              as PlaceImageFromDB?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DetailCopyWith<$Res> get detail {
    return $DetailCopyWith<$Res>(_value.detail, (value) {
      return _then(_value.copyWith(detail: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GeoDataCopyWith<$Res> get geoData {
    return $GeoDataCopyWith<$Res>(_value.geoData, (value) {
      return _then(_value.copyWith(geoData: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaceImageFromDBCopyWith<$Res>? get placeImages {
    if (_value.placeImages == null) {
      return null;
    }

    return $PlaceImageFromDBCopyWith<$Res>(_value.placeImages!, (value) {
      return _then(_value.copyWith(placeImages: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaceImplCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$$PlaceImplCopyWith(
          _$PlaceImpl value, $Res Function(_$PlaceImpl) then) =
      __$$PlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      bool active,
      int created,
      Detail detail,
      GeoData geoData,
      String name,
      int updated,
      int order,
      dynamic isReached,
      PlaceImageFromDB? placeImages});

  @override
  $DetailCopyWith<$Res> get detail;
  @override
  $GeoDataCopyWith<$Res> get geoData;
  @override
  $PlaceImageFromDBCopyWith<$Res>? get placeImages;
}

/// @nodoc
class __$$PlaceImplCopyWithImpl<$Res>
    extends _$PlaceCopyWithImpl<$Res, _$PlaceImpl>
    implements _$$PlaceImplCopyWith<$Res> {
  __$$PlaceImplCopyWithImpl(
      _$PlaceImpl _value, $Res Function(_$PlaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? active = null,
    Object? created = null,
    Object? detail = null,
    Object? geoData = null,
    Object? name = null,
    Object? updated = null,
    Object? order = null,
    Object? isReached = freezed,
    Object? placeImages = freezed,
  }) {
    return _then(_$PlaceImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as Detail,
      geoData: null == geoData
          ? _value.geoData
          : geoData // ignore: cast_nullable_to_non_nullable
              as GeoData,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isReached: freezed == isReached ? _value.isReached! : isReached,
      placeImages: freezed == placeImages
          ? _value.placeImages
          : placeImages // ignore: cast_nullable_to_non_nullable
              as PlaceImageFromDB?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceImpl with DiagnosticableTreeMixin implements _Place {
  const _$PlaceImpl(
      {this.id,
      required this.active,
      required this.created,
      required this.detail,
      required this.geoData,
      required this.name,
      required this.updated,
      required this.order,
      this.isReached = false,
      this.placeImages});

  factory _$PlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceImplFromJson(json);

  @override
  final String? id;
  @override
  final bool active;
  @override
  final int created;
  @override
  final Detail detail;
  @override
  final GeoData geoData;
  @override
  final String name;
  @override
  final int updated;
  @override
  final int order;
  @override
  @JsonKey()
  final dynamic isReached;
  @override
  final PlaceImageFromDB? placeImages;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Place(id: $id, active: $active, created: $created, detail: $detail, geoData: $geoData, name: $name, updated: $updated, order: $order, isReached: $isReached, placeImages: $placeImages)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Place'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('active', active))
      ..add(DiagnosticsProperty('created', created))
      ..add(DiagnosticsProperty('detail', detail))
      ..add(DiagnosticsProperty('geoData', geoData))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('updated', updated))
      ..add(DiagnosticsProperty('order', order))
      ..add(DiagnosticsProperty('isReached', isReached))
      ..add(DiagnosticsProperty('placeImages', placeImages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.geoData, geoData) || other.geoData == geoData) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(other.isReached, isReached) &&
            (identical(other.placeImages, placeImages) ||
                other.placeImages == placeImages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      active,
      created,
      detail,
      geoData,
      name,
      updated,
      order,
      const DeepCollectionEquality().hash(isReached),
      placeImages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      __$$PlaceImplCopyWithImpl<_$PlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceImplToJson(
      this,
    );
  }
}

abstract class _Place implements Place {
  const factory _Place(
      {final String? id,
      required final bool active,
      required final int created,
      required final Detail detail,
      required final GeoData geoData,
      required final String name,
      required final int updated,
      required final int order,
      final dynamic isReached,
      final PlaceImageFromDB? placeImages}) = _$PlaceImpl;

  factory _Place.fromJson(Map<String, dynamic> json) = _$PlaceImpl.fromJson;

  @override
  String? get id;
  @override
  bool get active;
  @override
  int get created;
  @override
  Detail get detail;
  @override
  GeoData get geoData;
  @override
  String get name;
  @override
  int get updated;
  @override
  int get order;
  @override
  dynamic get isReached;
  @override
  PlaceImageFromDB? get placeImages;
  @override
  @JsonKey(ignore: true)
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Detail _$DetailFromJson(Map<String, dynamic> json) {
  return _Detail.fromJson(json);
}

/// @nodoc
mixin _$Detail {
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DetailCopyWith<Detail> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailCopyWith<$Res> {
  factory $DetailCopyWith(Detail value, $Res Function(Detail) then) =
      _$DetailCopyWithImpl<$Res, Detail>;
  @useResult
  $Res call({String description});
}

/// @nodoc
class _$DetailCopyWithImpl<$Res, $Val extends Detail>
    implements $DetailCopyWith<$Res> {
  _$DetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DetailImplCopyWith<$Res> implements $DetailCopyWith<$Res> {
  factory _$$DetailImplCopyWith(
          _$DetailImpl value, $Res Function(_$DetailImpl) then) =
      __$$DetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description});
}

/// @nodoc
class __$$DetailImplCopyWithImpl<$Res>
    extends _$DetailCopyWithImpl<$Res, _$DetailImpl>
    implements _$$DetailImplCopyWith<$Res> {
  __$$DetailImplCopyWithImpl(
      _$DetailImpl _value, $Res Function(_$DetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
  }) {
    return _then(_$DetailImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailImpl with DiagnosticableTreeMixin implements _Detail {
  const _$DetailImpl({required this.description});

  factory _$DetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailImplFromJson(json);

  @override
  final String description;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Detail(description: $description)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Detail'))
      ..add(DiagnosticsProperty('description', description));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailImpl &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailImplCopyWith<_$DetailImpl> get copyWith =>
      __$$DetailImplCopyWithImpl<_$DetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailImplToJson(
      this,
    );
  }
}

abstract class _Detail implements Detail {
  const factory _Detail({required final String description}) = _$DetailImpl;

  factory _Detail.fromJson(Map<String, dynamic> json) = _$DetailImpl.fromJson;

  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$DetailImplCopyWith<_$DetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeoData _$GeoDataFromJson(Map<String, dynamic> json) {
  return _GeoData.fromJson(json);
}

/// @nodoc
mixin _$GeoData {
  Primary get primary => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeoDataCopyWith<GeoData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoDataCopyWith<$Res> {
  factory $GeoDataCopyWith(GeoData value, $Res Function(GeoData) then) =
      _$GeoDataCopyWithImpl<$Res, GeoData>;
  @useResult
  $Res call({Primary primary});

  $PrimaryCopyWith<$Res> get primary;
}

/// @nodoc
class _$GeoDataCopyWithImpl<$Res, $Val extends GeoData>
    implements $GeoDataCopyWith<$Res> {
  _$GeoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
  }) {
    return _then(_value.copyWith(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as Primary,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PrimaryCopyWith<$Res> get primary {
    return $PrimaryCopyWith<$Res>(_value.primary, (value) {
      return _then(_value.copyWith(primary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GeoDataImplCopyWith<$Res> implements $GeoDataCopyWith<$Res> {
  factory _$$GeoDataImplCopyWith(
          _$GeoDataImpl value, $Res Function(_$GeoDataImpl) then) =
      __$$GeoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Primary primary});

  @override
  $PrimaryCopyWith<$Res> get primary;
}

/// @nodoc
class __$$GeoDataImplCopyWithImpl<$Res>
    extends _$GeoDataCopyWithImpl<$Res, _$GeoDataImpl>
    implements _$$GeoDataImplCopyWith<$Res> {
  __$$GeoDataImplCopyWithImpl(
      _$GeoDataImpl _value, $Res Function(_$GeoDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
  }) {
    return _then(_$GeoDataImpl(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as Primary,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoDataImpl with DiagnosticableTreeMixin implements _GeoData {
  const _$GeoDataImpl({required this.primary});

  factory _$GeoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoDataImplFromJson(json);

  @override
  final Primary primary;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GeoData(primary: $primary)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GeoData'))
      ..add(DiagnosticsProperty('primary', primary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoDataImpl &&
            (identical(other.primary, primary) || other.primary == primary));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, primary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoDataImplCopyWith<_$GeoDataImpl> get copyWith =>
      __$$GeoDataImplCopyWithImpl<_$GeoDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoDataImplToJson(
      this,
    );
  }
}

abstract class _GeoData implements GeoData {
  const factory _GeoData({required final Primary primary}) = _$GeoDataImpl;

  factory _GeoData.fromJson(Map<String, dynamic> json) = _$GeoDataImpl.fromJson;

  @override
  Primary get primary;
  @override
  @JsonKey(ignore: true)
  _$$GeoDataImplCopyWith<_$GeoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Primary _$PrimaryFromJson(Map<String, dynamic> json) {
  return _Primary.fromJson(json);
}

/// @nodoc
mixin _$Primary {
  List<double> get coordinates => throw _privateConstructorUsedError;
  Fence get fence => throw _privateConstructorUsedError;
  List<double> get pixelCoordinates => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrimaryCopyWith<Primary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrimaryCopyWith<$Res> {
  factory $PrimaryCopyWith(Primary value, $Res Function(Primary) then) =
      _$PrimaryCopyWithImpl<$Res, Primary>;
  @useResult
  $Res call(
      {List<double> coordinates, Fence fence, List<double> pixelCoordinates});

  $FenceCopyWith<$Res> get fence;
}

/// @nodoc
class _$PrimaryCopyWithImpl<$Res, $Val extends Primary>
    implements $PrimaryCopyWith<$Res> {
  _$PrimaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? fence = null,
    Object? pixelCoordinates = null,
  }) {
    return _then(_value.copyWith(
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
      fence: null == fence
          ? _value.fence
          : fence // ignore: cast_nullable_to_non_nullable
              as Fence,
      pixelCoordinates: null == pixelCoordinates
          ? _value.pixelCoordinates
          : pixelCoordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FenceCopyWith<$Res> get fence {
    return $FenceCopyWith<$Res>(_value.fence, (value) {
      return _then(_value.copyWith(fence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrimaryImplCopyWith<$Res> implements $PrimaryCopyWith<$Res> {
  factory _$$PrimaryImplCopyWith(
          _$PrimaryImpl value, $Res Function(_$PrimaryImpl) then) =
      __$$PrimaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<double> coordinates, Fence fence, List<double> pixelCoordinates});

  @override
  $FenceCopyWith<$Res> get fence;
}

/// @nodoc
class __$$PrimaryImplCopyWithImpl<$Res>
    extends _$PrimaryCopyWithImpl<$Res, _$PrimaryImpl>
    implements _$$PrimaryImplCopyWith<$Res> {
  __$$PrimaryImplCopyWithImpl(
      _$PrimaryImpl _value, $Res Function(_$PrimaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? fence = null,
    Object? pixelCoordinates = null,
  }) {
    return _then(_$PrimaryImpl(
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
      fence: null == fence
          ? _value.fence
          : fence // ignore: cast_nullable_to_non_nullable
              as Fence,
      pixelCoordinates: null == pixelCoordinates
          ? _value._pixelCoordinates
          : pixelCoordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrimaryImpl with DiagnosticableTreeMixin implements _Primary {
  const _$PrimaryImpl(
      {required final List<double> coordinates,
      required this.fence,
      required final List<double> pixelCoordinates})
      : _coordinates = coordinates,
        _pixelCoordinates = pixelCoordinates;

  factory _$PrimaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrimaryImplFromJson(json);

  final List<double> _coordinates;
  @override
  List<double> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  final Fence fence;
  final List<double> _pixelCoordinates;
  @override
  List<double> get pixelCoordinates {
    if (_pixelCoordinates is EqualUnmodifiableListView)
      return _pixelCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pixelCoordinates);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Primary(coordinates: $coordinates, fence: $fence, pixelCoordinates: $pixelCoordinates)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Primary'))
      ..add(DiagnosticsProperty('coordinates', coordinates))
      ..add(DiagnosticsProperty('fence', fence))
      ..add(DiagnosticsProperty('pixelCoordinates', pixelCoordinates));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrimaryImpl &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.fence, fence) || other.fence == fence) &&
            const DeepCollectionEquality()
                .equals(other._pixelCoordinates, _pixelCoordinates));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_coordinates),
      fence,
      const DeepCollectionEquality().hash(_pixelCoordinates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrimaryImplCopyWith<_$PrimaryImpl> get copyWith =>
      __$$PrimaryImplCopyWithImpl<_$PrimaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrimaryImplToJson(
      this,
    );
  }
}

abstract class _Primary implements Primary {
  const factory _Primary(
      {required final List<double> coordinates,
      required final Fence fence,
      required final List<double> pixelCoordinates}) = _$PrimaryImpl;

  factory _Primary.fromJson(Map<String, dynamic> json) = _$PrimaryImpl.fromJson;

  @override
  List<double> get coordinates;
  @override
  Fence get fence;
  @override
  List<double> get pixelCoordinates;
  @override
  @JsonKey(ignore: true)
  _$$PrimaryImplCopyWith<_$PrimaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Fence _$FenceFromJson(Map<String, dynamic> json) {
  return _Fence.fromJson(json);
}

/// @nodoc
mixin _$Fence {
  int get radius => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FenceCopyWith<Fence> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FenceCopyWith<$Res> {
  factory $FenceCopyWith(Fence value, $Res Function(Fence) then) =
      _$FenceCopyWithImpl<$Res, Fence>;
  @useResult
  $Res call({int radius});
}

/// @nodoc
class _$FenceCopyWithImpl<$Res, $Val extends Fence>
    implements $FenceCopyWith<$Res> {
  _$FenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? radius = null,
  }) {
    return _then(_value.copyWith(
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FenceImplCopyWith<$Res> implements $FenceCopyWith<$Res> {
  factory _$$FenceImplCopyWith(
          _$FenceImpl value, $Res Function(_$FenceImpl) then) =
      __$$FenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int radius});
}

/// @nodoc
class __$$FenceImplCopyWithImpl<$Res>
    extends _$FenceCopyWithImpl<$Res, _$FenceImpl>
    implements _$$FenceImplCopyWith<$Res> {
  __$$FenceImplCopyWithImpl(
      _$FenceImpl _value, $Res Function(_$FenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? radius = null,
  }) {
    return _then(_$FenceImpl(
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FenceImpl with DiagnosticableTreeMixin implements _Fence {
  const _$FenceImpl({required this.radius});

  factory _$FenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$FenceImplFromJson(json);

  @override
  final int radius;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Fence(radius: $radius)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Fence'))
      ..add(DiagnosticsProperty('radius', radius));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FenceImpl &&
            (identical(other.radius, radius) || other.radius == radius));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, radius);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FenceImplCopyWith<_$FenceImpl> get copyWith =>
      __$$FenceImplCopyWithImpl<_$FenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FenceImplToJson(
      this,
    );
  }
}

abstract class _Fence implements Fence {
  const factory _Fence({required final int radius}) = _$FenceImpl;

  factory _Fence.fromJson(Map<String, dynamic> json) = _$FenceImpl.fromJson;

  @override
  int get radius;
  @override
  @JsonKey(ignore: true)
  _$$FenceImplCopyWith<_$FenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlaceImageFromDB _$PlaceImageFromDBFromJson(Map<String, dynamic> json) {
  return _PlaceImageFromDB.fromJson(json);
}

/// @nodoc
mixin _$PlaceImageFromDB {
  String? get placeId => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get stamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceImageFromDBCopyWith<PlaceImageFromDB> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceImageFromDBCopyWith<$Res> {
  factory $PlaceImageFromDBCopyWith(
          PlaceImageFromDB value, $Res Function(PlaceImageFromDB) then) =
      _$PlaceImageFromDBCopyWithImpl<$Res, PlaceImageFromDB>;
  @useResult
  $Res call({String? placeId, String location, String stamp});
}

/// @nodoc
class _$PlaceImageFromDBCopyWithImpl<$Res, $Val extends PlaceImageFromDB>
    implements $PlaceImageFromDBCopyWith<$Res> {
  _$PlaceImageFromDBCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = freezed,
    Object? location = null,
    Object? stamp = null,
  }) {
    return _then(_value.copyWith(
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      stamp: null == stamp
          ? _value.stamp
          : stamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceImageFromDBImplCopyWith<$Res>
    implements $PlaceImageFromDBCopyWith<$Res> {
  factory _$$PlaceImageFromDBImplCopyWith(_$PlaceImageFromDBImpl value,
          $Res Function(_$PlaceImageFromDBImpl) then) =
      __$$PlaceImageFromDBImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? placeId, String location, String stamp});
}

/// @nodoc
class __$$PlaceImageFromDBImplCopyWithImpl<$Res>
    extends _$PlaceImageFromDBCopyWithImpl<$Res, _$PlaceImageFromDBImpl>
    implements _$$PlaceImageFromDBImplCopyWith<$Res> {
  __$$PlaceImageFromDBImplCopyWithImpl(_$PlaceImageFromDBImpl _value,
      $Res Function(_$PlaceImageFromDBImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = freezed,
    Object? location = null,
    Object? stamp = null,
  }) {
    return _then(_$PlaceImageFromDBImpl(
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      stamp: null == stamp
          ? _value.stamp
          : stamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceImageFromDBImpl
    with DiagnosticableTreeMixin
    implements _PlaceImageFromDB {
  const _$PlaceImageFromDBImpl(
      {this.placeId, required this.location, required this.stamp});

  factory _$PlaceImageFromDBImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceImageFromDBImplFromJson(json);

  @override
  final String? placeId;
  @override
  final String location;
  @override
  final String stamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PlaceImageFromDB(placeId: $placeId, location: $location, stamp: $stamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PlaceImageFromDB'))
      ..add(DiagnosticsProperty('placeId', placeId))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('stamp', stamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceImageFromDBImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.stamp, stamp) || other.stamp == stamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, placeId, location, stamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceImageFromDBImplCopyWith<_$PlaceImageFromDBImpl> get copyWith =>
      __$$PlaceImageFromDBImplCopyWithImpl<_$PlaceImageFromDBImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceImageFromDBImplToJson(
      this,
    );
  }
}

abstract class _PlaceImageFromDB implements PlaceImageFromDB {
  const factory _PlaceImageFromDB(
      {final String? placeId,
      required final String location,
      required final String stamp}) = _$PlaceImageFromDBImpl;

  factory _PlaceImageFromDB.fromJson(Map<String, dynamic> json) =
      _$PlaceImageFromDBImpl.fromJson;

  @override
  String? get placeId;
  @override
  String get location;
  @override
  String get stamp;
  @override
  @JsonKey(ignore: true)
  _$$PlaceImageFromDBImplCopyWith<_$PlaceImageFromDBImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

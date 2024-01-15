class Place {
  final String name;
  final bool active;
  final int created;
  final int updated;
  final Detail detail;
  final GeoData geoData;

  Place({
    required this.name,
    required this.active,
    required this.created,
    required this.updated,
    required this.detail,
    required this.geoData,
  });
  @override
  String toString() {
    return 'Place(name: $name, latitude: ${geoData.primary.coordinates}';
  }

  factory Place.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    String? name = snapshot['name'] as String?;
    return Place(
      name: name ?? 'NULL',
      active: snapshot['active'] as bool,
      created: snapshot['created'] as int,
      updated: snapshot['updated'] as int,
      detail: Detail.fromSnapshot(snapshot['detail']),
      geoData: GeoData.fromSnapshot(snapshot['geoData']),
    );
  }
}

class Detail {
  final String description;
  final List<Image> images;

  Detail({required this.description, required this.images});

  factory Detail.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    var imageList = snapshot['images'] as List;
    List<Image> images = imageList.map((i) => Image.fromSnapshot(i)).toList();
    return Detail(
        description: snapshot['description'] as String, images: images);
  }
}

class Image {
  final String name;
  final String url;

  Image({required this.name, required this.url});

  factory Image.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    return Image(
      name: snapshot['name'] as String,
      url: snapshot['url'] as String,
    );
  }
}

class GeoData {
  final GeoPoint primary;
  final GeoPoint? secondary;

  GeoData({required this.primary, this.secondary});

  factory GeoData.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    return GeoData(
      primary: GeoPoint.fromSnapshot(snapshot['primary']),
      secondary: snapshot['secondary'] != null
          ? GeoPoint.fromSnapshot(snapshot['secondary'])
          : null,
    );
  }
}

class GeoPoint {
  final List<double> coordinates;
  final Fence? fence;

  GeoPoint({required this.coordinates, this.fence});

  factory GeoPoint.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    var coords = snapshot['coordinates'] as List;
    return GeoPoint(
      coordinates: coords.map((c) => c as double).toList(),
      fence: snapshot['fence'] != null
          ? Fence.fromSnapshot(snapshot['fence'])
          : null,
    );
  }
}

class Fence {
  final int radius;

  Fence({required this.radius});

  factory Fence.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    return Fence(radius: snapshot['radius'] as int);
  }
}

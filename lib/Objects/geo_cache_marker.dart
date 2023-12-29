import 'package:latlong2/latlong.dart';

class GeoCacheMarker {
  GeoCacheMarker({
    required this.position,
    required this.photo,
    required this.name,
    required this.id,
  });

  LatLng position;
  String photo;
  String name;
  String id;
}

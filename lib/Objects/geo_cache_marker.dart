import 'package:latlong2/latlong.dart';

/// GeoCacheMarker object
class GeoCacheMarker {
  /// Constructor for GeoCacheMarker object with required parameters
  GeoCacheMarker({
    required this.position,
    required this.photo,
    required this.name,
    required this.id,
  });

  /// Position of the marker on the map (latitude and longitude)
  LatLng position;

  /// Photo of the marker (URL)
  String photo;

  /// Name of the marker
  String name;

  /// Id of the marker (used to identify the marker in the database)
  String id;
}

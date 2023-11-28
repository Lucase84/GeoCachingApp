import 'package:http/http.dart' as http;

class MapManager {
  static Future<http.Response> createCache(
    String name,
    String description,
    String latitude,
    String longitude,
  ) async {
    return http.Response('', 200);
  }

  static Future<http.Response> getCaches() async {
    return http.Response('', 200);
  }

  static Future<http.Response> deleteCache(String id) async {
    return http.Response('', 200);
  }
}

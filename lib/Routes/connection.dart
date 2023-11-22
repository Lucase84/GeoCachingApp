import 'package:http/http.dart' as http;

class ConnectionManager {
  static const String url = '';

  static Future<http.Response> login(
    String email,
    String password,
  ) async {
    // wait for 1 seconds to simulate a network call
    return http.Response('', 200);
  }

  static Future<http.Response> register(
    String username,
    String email,
    String password,
  ) async {
    return http.Response('', 200);
  }
}

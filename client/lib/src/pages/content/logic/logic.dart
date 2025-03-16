import 'dart:convert';
import 'package:client/src/utils/securityControl.dart';
import 'package:http/http.dart' as http;

class SpotifyLogic {
  static const String baseUrl = 'http://localhost:8000';

  static Future<Map<String, dynamic>> searchCountry(String country) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return {};

    final url = Uri.parse('$baseUrl/spotify/country/$country');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'jwt': token}),
    );
    print('Response status: ${response.statusCode}');
    return response.body.isNotEmpty ? jsonDecode(response.body) : {};
  }

  static Future<Map<String, dynamic>> searchGlobal() async {

    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return {};

    final url = Uri.parse('$baseUrl/spotify/global');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'jwt': token}),
    );
    print('Response status: ${response.statusCode}');
    return response.body.isNotEmpty ? jsonDecode(response.body) : {};
  }

  static Future<Map<String, dynamic>> searchUser(String userId) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return {};

    final url = Uri.parse('$baseUrl/user/$userId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'jwt': token}),
    );
    print('Response status: ${response.statusCode}');
    return response.body.isNotEmpty ? jsonDecode(response.body) : {};
  }
}
import 'dart:convert';
import 'package:client/src/models/history.dart';
import 'package:client/src/utils/securityControl.dart';
import 'package:http/http.dart' as http;
import 'package:client/src/models/track.dart';

class UserLogic {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<TrackModel>> fetchUserTracks() async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return [];

    final response = await http.post(
      Uri.parse('$baseUrl/user/track/get'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jwt': token}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> tracksJson = data['tracks'];
      return tracksJson.map((json) => TrackModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  static Future<bool> deleteTrack(String id) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('$baseUrl/user/track/delete/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jwt': token}),
    );

    if (response.statusCode == 204) {
      return true;
    }
    return false;
  }

  static Future<List<History>> fetchUserHistory() async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return [];

    final response = await http.post(
      Uri.parse('$baseUrl/user/history/get'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jwt': token}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> historyJson = data['history'];
      return historyJson.map((json) => History.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }

  static Future<bool> addHistory(History history) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/user/history/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'jwt': token,
        'history': history.toJson(),
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    }
  
    return false;
  }

  static Future<bool> deleteHistory(String id) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('$baseUrl/user/history/delete/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jwt': token}),
    );

    if (response.statusCode == 204) {
      return true;
    }
    return false;
  }
}

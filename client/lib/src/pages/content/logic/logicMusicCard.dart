import 'package:client/src/models/track.dart';
import 'package:client/src/utils/securityControl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicCardLogic {
  static const String baseUrl = 'http://localhost:8000';

  static Future<bool> saveTrack(TrackModel trackModel) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return false;
    
    final url = Uri.parse('$baseUrl/user/track/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
      'jwt': token,
      'track':trackModel.toJson(),
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } 
    print(response.statusCode);
    return false;
  }
}

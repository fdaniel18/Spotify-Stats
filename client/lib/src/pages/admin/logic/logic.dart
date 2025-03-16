import 'package:client/src/models/user.dart';
import 'package:client/src/utils/securityControl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLogic {
  static Future<List<User>?> fetchUsers() async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();

    if (token == null) return [];

    final userUri = Uri.parse('http://localhost:8000/users');
    final response = await http.post(
      userUri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'jwt': token,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((data) => User.fromJson(data as Map<String, dynamic>))
          .toList();
    } else {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
    return [];
  }

  static Future<bool> deleteUser(String userId) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return false;

    final deleteUri = Uri.parse('http://localhost:8000/user/$userId');
    final response = await http.delete(
      deleteUri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'jwt': token,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 204) {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      return false;
    }
    return true;
  }

  static Future<bool> updateUser(String userId, String firstName,
      String lastName, String email, bool role) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return false;

    final updateUri = Uri.parse('http://localhost:8000/user/$userId');
    final response = await http.put(
      updateUri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'jwt': token,
        'id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,

        'is_admin': role,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 202) {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      return false;
    }
    return true;
  }

  static Future<bool> createUser(String email, String firstName, String lastName, bool role) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) return false;

    final uri = Uri.parse('http://localhost:8000/user/create');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'jwt': token,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': '1234', // default password
        'is_admin': role,
      }),
    );
    print(
      jsonEncode({
        'jwt': token,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': '1234', // default password
        'is_admin': role,
      }),
    );
    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode != 201) {
      return false;
    }

    return true;
  }
}

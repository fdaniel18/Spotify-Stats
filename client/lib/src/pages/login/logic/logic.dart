import 'package:client/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/src/utils/userSingleton.dart';
import 'package:client/src/utils/securityControl.dart';

class LoginLogic {
  
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF1ED760),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<String?> validateLogin(String email, String password) async {

    if (email.isEmpty || password.isEmpty) {
      return 'Please fill in both fields.';
    }

    if (!email.contains("@") || !email.contains(".com")) {
      return 'Please fill a valid email.';
    }

    final uri = Uri.parse('http://localhost:8000/login');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      return 'The email or password is incorrect.';
    }
    //the account is valid
    String token = jsonDecode(response.body)['jwt'];
    SecurityControl securityControl = SecurityControl();
    await securityControl.setToken(token);

    print(token);
    final userUri = Uri.parse('http://localhost:8000/user/current');
    final userResponse = await http.post(
      userUri,
      headers: {
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
      'jwt': token,
      }),
    );

    print(userResponse.body);
    if (userResponse.statusCode != 200) {
      return 'Internal server error';
    }

    User user =
        User.fromJson(jsonDecode(userResponse.body) as Map<String, dynamic>);
    UserSingleton.setUser(user);
    print("User: ${UserSingleton.getUser()}");
    return null;
  }

  static Future<bool> verifyToken() async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) {
      return false;
    }

    final uri = Uri.parse('http://localhost:8000/user/current');
    final response = await http.post(
      uri,
      headers: {
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
      'jwt': token,
      }),
    );

    if (response.statusCode != 200) {
      return false;
    }

    User user =
        User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    UserSingleton.setUser(user);
    print("User: ${UserSingleton.getUser()}");
    return true;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/src/models/user.dart';
import 'package:client/src/utils/securityControl.dart';

class UserSingleton {
  static User? _user;

  static void setUser(User user) {
    _user = user;
  }

  static User? getUser() {
    return _user;
  }

  static Future<bool> reloadUser() async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) {
      return false;
    }
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

    if (userResponse.statusCode != 200) {
      return false;
    }

    User user =
        User.fromJson(jsonDecode(userResponse.body) as Map<String, dynamic>);
    setUser(user);
    return true;
  }
}

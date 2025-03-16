import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpLogic {
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

  static void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Success'),
          content: const Text('You have successfully signed up!'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF1ED760),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/login'); // Adjust as needed
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<String?> validateSignUp(String email, String password,
      String repeatPassword, String fullName) async {
    if (email.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      return 'Please fill in all fields.';
    }

    // Validate email format
    if (!email.contains('@') || !email.contains('.com')) {
      return 'Please enter a valid email address.';
    }

    if (password != repeatPassword) {
      return 'Passwords do not match.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    if (fullName.isEmpty) {
      return 'Please enter your full name.';
    }
    if (fullName.length < 3) {
      return 'Full name must be at least 3 characters long.';
    }

    final uri = Uri.parse('http://localhost:8000/register');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'first_name': fullName.split(' ').first,
        'last_name': fullName.split(' ').last,
        'email': email,
        'password': password,
      }),
    );

    print("Response status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      return 'Failed to sign up: ${response.reasonPhrase}';
    }

    return null; 
  }
}

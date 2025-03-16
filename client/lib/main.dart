import 'package:flutter/material.dart';
import 'package:client/src/pages/login/login_page.dart';
import 'package:client/src/pages/signup/signup_page.dart';
import 'package:client/src/pages/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Stats', 
      initialRoute: '/login', // Set the initial route
      routes: {
        '/login': (context) => const LogInPage(),
        '/signup': (context) => const SignupPage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}

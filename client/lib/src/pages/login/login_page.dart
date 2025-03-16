import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/social_login_button.dart';
import 'widgets/text_input_field.dart';
import 'logic/logic.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email = '';
  String password = '';

  void _login() async {
    // Validate credentials using the logic class
    String? errorMessage = await LoginLogic.validateLogin(email, password);
    print(errorMessage);
    if (errorMessage != null) {
      LoginLogic.showErrorDialog(context, errorMessage);
    }else{
      Navigator.pushNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginLogic.verifyToken().then((isValid) {
      print(isValid);
      if (isValid) {
        Navigator.pushNamed(context, '/main');
      }
    });

    double width = MediaQuery.of(context).size.width * 0.35;
    double buttonWidth = MediaQuery.of(context).size.width * 0.2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 150,
                ),
                const SizedBox(height: 64),

                // Social Login Buttons
                SocialLoginButton(
                  icon: Icons.facebook,
                  text: 'CONTINUE WITH FACEBOOK',
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  width: width,
                ),
                const SizedBox(height: 8),
                SocialLoginButton(
                  icon: Icons.apple,
                  text: 'CONTINUE WITH APPLE',
                  textColor: Colors.white,
                  backgroundColor: Colors.black,
                  width: width,
                ),
                const SizedBox(height: 8),
                SocialLoginButton(
                  icon: Icons.g_mobiledata_rounded,
                  text: 'CONTINUE WITH GOOGLE',
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  width: width,
                ),

                const SizedBox(height: 16),
                const Text('OR', style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 16),
                TextInputField(
                  labelText: 'Email address',
                  obscureText: false,
                  width: width,
                  onChanged: (value) {
                    email = value; // Update the email variable
                  },
                ),
                const SizedBox(height: 8),
                TextInputField(
                  labelText: 'Password',
                  obscureText: true,
                  width: width,
                  onChanged: (value) {
                    password = value; // Update the password variable
                  },
                ),

                const SizedBox(height: 8),
                // Forgot Password Link
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      surfaceTintColor: Colors.black,
                      overlayColor: Colors.black,
                    ),
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Log In Button
                ElevatedButton(
                  onPressed: _login, // Call the login function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ED760),
                    minimumSize: Size(buttonWidth, 48),
                  ),
                  child: const Text('LOG IN', style: TextStyle(color: Colors.black)),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: width,
                  child: const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 20,
                  ),
                ),

                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: const BorderSide(color: Colors.black, width: 0.2), // Thin black border
                    minimumSize: Size(buttonWidth, 48),
                  ),
                  child: const Text(
                    'SIGN UP FOR SPOTIFY',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

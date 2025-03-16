import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/src/pages/signup/widgets/social_login_button.dart';
import 'package:client/src/pages/signup/widgets/text_input_field.dart';
import 'package:client/src/pages/signup/logic/logic.dart'; 

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullNameController = TextEditingController();  // Add controller for full name
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  void _signUp() async {
    String fullName = _fullNameController.text.trim();  // Capture full name
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String repeatPassword = _repeatPasswordController.text.trim();

    // Validate credentials using the logic class
    String? errorMessage = await SignUpLogic.validateSignUp(email, password, repeatPassword, fullName);  // Pass full name to validation method
    
    if (errorMessage != null) {
      SignUpLogic.showErrorDialog(context, errorMessage);
      return;
    }

    // Proceed with sign-up logic (e.g., API call)
    // Simulate successful signup
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _repeatPasswordController.clear();

    // Show success dialog
    SignUpLogic.showSuccessDialog(context);
  }

  @override
  void dispose() {
    _fullNameController.dispose();  // Dispose the full name controller
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                // Full Name Input
                TextInputField(
                  labelText: 'Full Name',  // Added Full Name field
                  obscureText: false,
                  width: width,
                  controller: _fullNameController, 
                ),
                const SizedBox(height: 8),
                TextInputField(
                  labelText: 'Email address',
                  obscureText: false,
                  width: width,
                  controller: _emailController, 
                ),
                const SizedBox(height: 8),
                TextInputField(
                  labelText: 'Password',
                  obscureText: true,
                  width: width,
                  controller: _passwordController, 
                ),
                const SizedBox(height: 8),
                TextInputField(
                  labelText: 'Repeat Password',
                  obscureText: true,
                  width: width,
                  controller: _repeatPasswordController, 
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _signUp, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ED760),
                    minimumSize: Size(buttonWidth, 48),
                  ),
                  child: const Text('SIGN UP', style: TextStyle(color: Colors.black)),
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
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),

                // Log In Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    side: const BorderSide(color: Colors.black, width: 0.2), 
                    minimumSize: Size(buttonWidth, 48),
                  ),
                  child: const Text(
                    'LOG IN TO SPOTIFY',
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

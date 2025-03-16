import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final double width;
  final TextEditingController controller; // Add this line

  const TextInputField({
    super.key,
    required this.labelText,
    required this.obscureText,
    required this.width,
    required this.controller, // Add this line
  });

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; 
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width, 
      child: TextField(
        controller: widget.controller, // Use the controller
        obscureText: _isObscure, 
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          suffixIcon: widget.labelText == "Password"
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null, 
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final double width;
  final ValueChanged<String> onChanged; // Added onChanged parameter

  const TextInputField({
    super.key,
    required this.labelText,
    required this.obscureText,
    required this.width,
    required this.onChanged, // Required for callback
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
        obscureText: _isObscure, 
        style: const TextStyle(color: Colors.black),
        onChanged: widget.onChanged, // Capture the input
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

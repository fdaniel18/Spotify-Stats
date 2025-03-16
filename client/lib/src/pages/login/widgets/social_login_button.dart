import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double width;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: textColor),
      label: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: backgroundColor == Colors.white ? Colors.black : Colors.transparent,
            width: 0.1,
          ),
        ),
      ),
    );
  }
}

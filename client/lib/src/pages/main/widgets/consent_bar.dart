import 'package:flutter/material.dart';

class ConsentBar extends StatelessWidget {
  final VoidCallback onConsent;

  const ConsentBar({super.key, required this.onConsent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 174, 30, 148),
            Color(0xFF8A2387),
            Color.fromARGB(255, 89, 155, 222),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          // Expanded widget to center the text within available space
          const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "By using this site, you need to consent to the use of cookies.",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Consent button aligned to the right
          ElevatedButton(
            onPressed: onConsent,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "CONSENT",
              style: TextStyle(color: Colors.black), // Black text for contrast
            ),
          ),
        ],
      ),
    );
  }
}

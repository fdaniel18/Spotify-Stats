import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart'; // Import the auto_size_text package

class MusicMoodCard extends StatelessWidget {
  final String mood; // Mood passed as input

  const MusicMoodCard({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 65, 65),
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),  // Dark shadow effect
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(2, 4), // Position of the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static text for "The average mood is"
          const Text(
            'The average mood is ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24, 
              fontWeight: FontWeight.bold,
            ),
          ),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Color(0xFF1DB954), Colors.white, Color(0xFF1DB954)], // Gradient from green to white
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: AutoSizeText(
              mood,  
              style: const TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 35,  
              maxFontSize: 40,  
              maxLines: 1,      
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'track_tile.dart';
import 'package:client/src/models/track.dart';

class TopTracksList extends StatelessWidget {
  final List<TrackModel> tracks;

  const TopTracksList({
    super.key,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(206, 65, 65, 65),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top tracks:',
            style: TextStyle(
              fontSize: 16, // Reduced font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6), // Reduced spacing

          // Clip the overflowing ListView content
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Optional, for rounded corners
              child: ListView.builder(
                itemCount: tracks.length,
                physics: const BouncingScrollPhysics(), // Smooth scrolling
                itemBuilder: (context, index) {
                  return TrackTile(track: tracks[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:client/src/pages/content/logic/logicMusicCard.dart';
import 'package:flutter/material.dart';
import 'package:client/src/models/track.dart';

class TrackTile extends StatelessWidget {
  final TrackModel track;

  const TrackTile({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 95, 95, 95),
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(2.5),
      child: Row(
        children: [
          // Image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              track.image300,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                  child: const Icon(Icons.error, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Text(
              track.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, 
            ),
          ),
          
          // Save button styled in Spotify's green color
          TextButton(
            onPressed: () async {
                track.date = DateTime.now().toString().substring(0, 10).trim();
                bool result = await MusicCardLogic.saveTrack(track);
                final snackBar = SnackBar(
                content: Text(result ? 'Track saved successfully!' : 'Failed to save track.'),
                backgroundColor: result ? Colors.green : Colors.red,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1DB954), // Spotify green
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
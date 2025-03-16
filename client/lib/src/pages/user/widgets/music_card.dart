import 'package:client/src/pages/user/logic/userLogic.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicCard extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String author;
  final String dateSaved;
  final String spotifyId;
  final double width;
  final double height;

  const MusicCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.dateSaved,
    required this.spotifyId,
    this.width = 250.0,
    this.height = 300.0,
  });

  @override
  _MusicCardState createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  bool _isVisible = true;

  // Function to launch the Spotify link using the ID
  Future<void> _launchSpotify(BuildContext context) async {
    final Uri url = Uri.parse('https://open.spotify.com/track/${widget.spotifyId}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Spotify link opened successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show a snackbar if the URL can't be launched
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Spotify link!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // Function to handle delete action
  void _handleDelete() async {
    setState(() {
      _isVisible = false;
    });
    bool answer = await UserLogic.deleteTrack(widget.id);
    if (answer) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item successfully deleted!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _isVisible = true;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete item!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return Container();

    final fontSizeTitle = widget.width * 0.08;
    final fontSizeAuthor = widget.width * 0.07;
    final fontSizeDate = widget.width * 0.06;

    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 65, 65),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(102),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            widget.imageUrl,
            width: widget.width * 0.7,
            height: widget.height * 0.55,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.broken_image,
              size: widget.width * 0.7,
              color: Colors.grey,
            ),
          ),
          const Spacer(),

          // Row with text details and button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Music Title
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Author
                    Text(
                      widget.author,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: fontSizeAuthor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Date Saved
                    Text(
                      widget.dateSaved,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: fontSizeDate,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _launchSpotify(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 30, 215, 96), // Spotify green color
                          padding: const EdgeInsets.all(10), // Padding for the button
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                            size: 24, // Ensure the icon is centered and appropriately sized
                          ),
                        ),
                      ),
                      DeleteButton(onDelete: _handleDelete),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Delete button widget
class DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteButton({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        // Show a confirmation dialog before deleting
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const Text('Confirm Delete', style: TextStyle(color: Colors.white)),
              content: const Text('Are you sure you want to delete this item?', style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
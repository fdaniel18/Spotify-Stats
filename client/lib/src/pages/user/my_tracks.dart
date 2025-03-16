import 'package:client/src/pages/user/logic/userLogic.dart';
import 'package:flutter/material.dart';
import 'package:client/src/models/track.dart';
import 'widgets/music_card.dart';

class UserTracks extends StatefulWidget {
  const UserTracks({super.key});

  @override
  _UserTracksState createState() => _UserTracksState();
}

class _UserTracksState extends State<UserTracks> {
  late Future<List<TrackModel>> futureTracks;

  @override
  void initState() {
    super.initState();
    futureTracks = UserLogic.fetchUserTracks();
  }

  // Group the tracks by month (for simplicity, we assume the date is in "yyyy-MM-dd" format)
  Map<String, List<TrackModel>> getTracksByMonth(List<TrackModel> tracks) {
    Map<String, List<TrackModel>> groupedTracks = {};

    for (var track in tracks) {
      final String dateSaved = track.date;
      if (dateSaved.length >= 7) {
        final String monthYear = dateSaved.substring(0, 7); // Extract "yyyy-MM"
        if (groupedTracks.containsKey(monthYear)) {
          groupedTracks[monthYear]!.add(track);
        } else {
          groupedTracks[monthYear] = [track];
        }
      }
    }

    return groupedTracks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Tracks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<TrackModel>>(
        future: futureTracks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Something went wrong!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.refresh,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please try again later.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final tracksByMonth = getTracksByMonth(snapshot.data!);

            return PageView(
              scrollDirection: Axis.vertical,
              children: [
                // Introductory Page
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 100,
                          color: Colors.green,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Here are your saved tracks!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Scroll down to explore your saved tracks.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Press the button on the card to go to the track on Spotify!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Icon(
                          Icons.arrow_downward,
                          size: 50,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                // Page for each month of saved tracks
                for (var monthYear in tracksByMonth.keys)
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display month/year header with shadow
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Container(
                            width: double.infinity,
                            height: 25,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 30, 215, 96),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                monthYear,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Horizontal scrollable track list
                        Container(
                          height: 300,
                          padding: const EdgeInsets.only(left: 10),
                          child: Scrollbar(
                            trackVisibility: true,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: tracksByMonth[monthYear]!.length,
                              itemBuilder: (context, index) {
                                final track = tracksByMonth[monthYear]![index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: MusicCard(
                                    id: track.id,
                                    imageUrl: track.image300,
                                    title: track.name,
                                    author: track.author,
                                    spotifyId: track.spotify_id,
                                    width: 200.0,
                                    height: 250.0,
                                    dateSaved: track.date,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          } else {
            return const Center(
              child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Icon(
                  Icons.library_music,
                  color: Colors.white,
                  size: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'No data available',
                  style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please try again later.',
                  style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                ],
              ),
              ),
            );
          }
        },
      ),
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1), // Set background color to gray
    );
  }
}
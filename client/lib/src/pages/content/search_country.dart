import 'package:client/src/models/history.dart';
import 'package:client/src/models/track.dart';
import 'package:client/src/pages/content/logic/logic.dart';
import 'package:client/src/pages/content/widgets/music_mood_card.dart';
import 'package:client/src/pages/content/widgets/music_mood_chart.dart';
import 'package:client/src/pages/content/widgets/title_container.dart';
import 'package:client/src/pages/user/logic/userLogic.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:client/src/pages/content/widgets/search_bar.dart';
import 'widgets/top_track_list.dart';

class SearchByCountryPage extends StatefulWidget {
  const SearchByCountryPage({super.key});

  @override
  _SearchByCountryPageState createState() => _SearchByCountryPageState();
}

class _SearchByCountryPageState extends State<SearchByCountryPage> {
  Future<Map<String, dynamic>>? futureMusicData;
  Map<String, String> abreviation = {
    'United States': 'US',
    'United Kingdom': 'UK',
    'Romania': 'RO',
    'France': 'FR',
  };
  void handleSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        futureMusicData = SpotifyLogic.searchCountry(abreviation[query]!);
        UserLogic.addHistory(History(
          id: 0,
          type: 'Search: $query',
          date: DateTime.now(),
        ));
      }else{
        futureMusicData = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: Column(
        children: [
          CustomSearchBar(onSearch: handleSearch),
          Expanded(
            child: futureMusicData == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const Icon(Icons.search_off, color: Colors.green, size: 256),
                    const Text(
                      'No data available',
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please try searching for a different country.',
                      style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Available countries: ${abreviation.keys.join(', ')}',
                      style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ],
                  ),
                  )
                : FutureBuilder<Map<String, dynamic>>(
                    future: futureMusicData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(
                          color: Colors.white ,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                            'Something went wrong!',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            ),
                          ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final tracks = (snapshot.data!['track_data'] as List)
                            .map((item) => TrackModel.fromJson(item))
                            .toList();
                        final musicData = (snapshot.data!['music_data'] as List)
                            .map((item) => List<double>.from(item))
                            .toList();
                        final result = snapshot.data!['result'] as String;
                        final arousalSpots = musicData.map((e) => e[1]).toList();
                        final valenceSpots = musicData.map((e) => e[0]).toList();

                        return SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: const Color.fromRGBO(36, 36, 36, 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TitleContainer with country title and flag
                                TitleContainer(
                                  title: snapshot.data!['country'].split('?').first as String,
                                  icon: CountryFlag.fromCountryCode(snapshot.data!['country'].split('?')[1]), 
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            MusicMoodCard(mood: result),
                                            const SizedBox(height: 16),
                                            Expanded(
                                              child: MusicMoodChart(
                                                arousalValues: arousalSpots,
                                                valenceValues: valenceSpots,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: TopTracksList(tracks: tracks),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
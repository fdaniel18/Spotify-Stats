import 'package:client/src/pages/content/logic/logic.dart';
import 'package:flutter/material.dart';
import 'package:client/src/pages/content/widgets/search_bar.dart';

class SearchByUserPage extends StatefulWidget {
  const SearchByUserPage({super.key});

  @override
  _SearchByUserPageState createState() => _SearchByUserPageState();
}

class _SearchByUserPageState extends State<SearchByUserPage> {
  late Future<Map<String, dynamic>> futureMusicData;

  void handleSearch(String query) {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    futureMusicData = SpotifyLogic.searchUser('initial query'); // Initial data fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: Column(
        children: [
          CustomSearchBar(onSearch: handleSearch),
          const Expanded(
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                Icons.warning,
                color: Colors.red,
                size: 50,
                ),
                SizedBox(height: 20),
                Text(
                'This page is deprecated due to changes in the Spotify API.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                ),
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
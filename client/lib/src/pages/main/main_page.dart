import 'package:client/src/pages/admin/admin_page.dart';
import 'package:client/src/pages/content/search_country.dart';
import 'package:client/src/pages/content/search_global.dart';
import 'package:client/src/pages/content/search_user.dart';
import 'package:client/src/pages/user/my_history.dart';
import 'package:client/src/pages/user/my_tracks.dart';
import 'package:flutter/material.dart';
import 'widgets/sidebar.dart';
import 'widgets/consent_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _showConsentBar = true; 

  // List of content pages
  final List<Widget> _pages = [
    const SearchByCountryPage(),
    const SearchGlobalPage(),
    const SearchByUserPage(),
    const UserTracks(),
    const UserHistory(),
    const AdminPage()
  ];

  void _onSelectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onConsent() {
    setState(() {
      _showConsentBar = false; // Hide consent bar on consent
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 65, 65, 65),
      body: Stack(
        children: [
          Row(
            children: [
              Sidebar(
                onSelectPage: _onSelectPage,
                selectedIndex: _selectedIndex, 
              ),

              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),

          // ConsentBar positioned at the bottom of the screen
          if (_showConsentBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ConsentBar(onConsent: _onConsent),
            ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:client/src/models/user.dart';
import 'package:client/src/utils/securityControl.dart';
import 'package:client/src/utils/userSingleton.dart';
import 'package:flutter/material.dart';
import 'sidebar_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class Sidebar extends StatefulWidget {
  final Function(int) onSelectPage;
  final int selectedIndex;

  const Sidebar({
    super.key,
    required this.onSelectPage,
    required this.selectedIndex,
  });

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });

    bool answer = false;
    if(_user == null) {
      answer = await UserSingleton.reloadUser();
    }
    if(!answer) {
      SecurityControl().clearToken();
      Navigator.pushReplacementNamed(context, '/login');
    }

    _user = UserSingleton.getUser();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SecurityControl securityControl = SecurityControl();
    String? token = await securityControl.getToken();
    if (token == null) const SnackBar(content: Text('Failed to log out'));

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jwt': token!,
        }),
      );

      if (response.statusCode == 200) {
        SecurityControl().clearToken();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to log out')),
        );
      }

      SecurityControl().clearToken();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while logging out')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 30),
          SvgPicture.asset(
            'assets/images/logoWhite.svg',
            height: 70,
          ),
          const SizedBox(height: 100),

          // Sidebar Buttons with highlighting
          SidebarButton(
            icon: Icons.location_on,
            text: 'Search Country',
            isSelected: widget.selectedIndex == 0,
            onPressed: () => widget.onSelectPage(0),
          ),
          SidebarButton(
            icon: Icons.public,
            text: 'Search Global',
            isSelected: widget.selectedIndex == 1,
            onPressed: () => widget.onSelectPage(1),
          ),
          SidebarButton(
            icon: Icons.person,
            text: 'Search User',
            isSelected: widget.selectedIndex == 2,
            onPressed: () => widget.onSelectPage(2),
          ),

          const Spacer(),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SidebarButton(
                icon: Icons.library_music,
                text: 'My Tracks',
                isSelected: widget.selectedIndex == 3,
                onPressed: () => widget.onSelectPage(3),
              ),
              SidebarButton(
                icon: Icons.history,
                text: 'My History',
                isSelected: widget.selectedIndex == 4,
                onPressed: () => widget.onSelectPage(4),
              ),
              if (_user !=null && _user!.isAdmin)
                SidebarButton(
                  icon: Icons.admin_panel_settings,
                  text: 'Admin Dashboard',
                  isSelected: widget.selectedIndex == 5,
                  onPressed: () => widget.onSelectPage(5),
                ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  if (_isLoading)
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  else
                    Text(
                      _user != null
                          ? '${_user!.firstName} ${_user!.lastName}'
                          : 'User',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _logout(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

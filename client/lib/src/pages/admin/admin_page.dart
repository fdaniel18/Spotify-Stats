import 'package:client/src/models/user.dart';
import 'package:client/src/pages/admin/logic/logic.dart';
import 'package:flutter/material.dart';
import 'widgets/user_table.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to the Admin Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Here you can manage users, view statistics, and more.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              // Down arrow with message
              Column(
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 40,
                    color: Colors.grey,
                  ),
                  Text(
                    'Swipe up for more',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          // Second screen - User management table
          FutureBuilder<List<User>?>(
            future: AdminLogic.fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to fetch users: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[900],
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'User Management',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        UserTable(userData: snapshot.data!), // Pass the fetched data
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:bt_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // get user from shared preferences
  // show user name and email
  // show logout button
  // when logout button is clicked, remove token from shared preferences and navigate to login screen

  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text('Welcome to Home Screen, ${user?.lastName}'),
            ElevatedButton(
              onPressed: () {
                _logout();
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }

  Future _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    // parse json string to user object
    print(userString);
    if (userString != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userString));
      });
    }
  }

  Future _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user');
    Navigator.pushNamed(context, '/login');
  }
}

import 'package:bt_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu thành viên'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            _buildTeamMember('Nguyễn Đức Phú', '21110845'),
            _buildTeamMember('Nguyễn Trọng Phúc', '21110846'),
            _buildTeamMember('Phạm Quốc Hưng', '21110'),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(role),
        const SizedBox(height: 10),
      ],
    );
  }
}

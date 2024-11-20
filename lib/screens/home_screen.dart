import 'dart:convert';
import 'package:bt_flutter/screens/permission_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bt_flutter/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  bool isLoading = true; // Trạng thái tải dữ liệu
  int _selectedIndex = 0; // Vị trí hiện tại trong BottomNavigationBar

  // Danh sách các trang cho từng mục
  final List<Widget> _pages = [
    const ManageDepartmentsPage(),
    const PermissionDoctorScreen(),
  ];

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
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  _showUserInfo(context);
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Placeholder image
                  ),
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex], // Hiển thị trang tương ứng
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Thay đổi trang
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Quản lý khoa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Duyệt bác sĩ',
          ),
        ],
      ),
    );
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userString));
      });
    }
    setState(() {
      isLoading = false; // Dừng trạng thái tải
    });
  }

  void _showUserInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user!.lastName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  user!.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Trang quản lý khoa
class ManageDepartmentsPage extends StatelessWidget {
  const ManageDepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.business, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Quản lý khoa',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Trang duyệt bác sĩ
// class ApproveDoctorsPage extends StatelessWidget {
//   PermissionDoctorScreen({super.key});


// }

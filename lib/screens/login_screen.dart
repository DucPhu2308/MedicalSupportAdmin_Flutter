import 'dart:convert';

import 'package:bt_flutter/api/auth_api.dart';
import 'package:bt_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Giải phóng các controller khi không còn cần thiết
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            MyTextField(label: 'Email', controller: _emailController),
            MyTextField(
                label: 'Mật khẩu',
                controller: _passwordController,
                isPassword: true),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Vui lòng nhập đầy đủ thông tin',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                AuthAPI.login(
                  _emailController.text,
                  _passwordController.text,
                ).then((value) async {
                  if (value['statusCode'] == 401) {
                    Fluttertoast.showToast(
                      msg: 'Email hoặc mật khẩu không đúng',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  final String token = value['token'].toString();
                  final user = value['user'];
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString('token', token);
                  prefs.setString('user', jsonEncode(user));
                  Navigator.pushNamed(context, '/home');
                });
              },
              child: const Text('Đăng nhập'),
            ),
            // Chưa có tài khoản? Đăng ký ngay
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Chưa có tài khoản? Đăng ký ngay'),
            ),
            // Quên mật khẩu
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text('Quên mật khẩu?'),
            ),
          ],
        ),
      ),
    );
  }
}

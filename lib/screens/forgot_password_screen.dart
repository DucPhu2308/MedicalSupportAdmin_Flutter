import 'package:bt_flutter/api/auth_api.dart';
import 'package:bt_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            MyTextField(
                controller: _emailController, label: 'Nhập email đã đăng ký'),
            ElevatedButton(
              onPressed: () {
                AuthAPI.forgotPassword(_emailController.text).then((value) {
                  Navigator.pushReplacementNamed(context, '/reset-password',
                      arguments: _emailController.text);
                });
              },
              child: const Text('Gửi mã OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

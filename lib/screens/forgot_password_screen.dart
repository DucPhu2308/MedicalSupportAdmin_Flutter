import 'package:bt_flutter/api/auth_api.dart';
import 'package:bt_flutter/layouts/default_layout_log_reg.dart';
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
    return DefaultLayoutLogReg(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'QUÊN MẬT KHẨU',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                    controller: _emailController,
                    label: 'Nhập email đã đăng ký'),
                ElevatedButton(
                  onPressed: () {
                    AuthAPI.forgotPassword(_emailController.text).then((value) {
                      Navigator.pushReplacementNamed(context, '/reset-password',
                          arguments: _emailController.text);
                    });
                  },
                  child: const Text('Gửi mã OTP'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Quay lại đăng nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

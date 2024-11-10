import 'package:bt_flutter/api/auth_api.dart';
import 'package:bt_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? email = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            MyTextField(controller: _otpController, label: 'Nhập mã OTP'),
            ElevatedButton(
              onPressed: () {
                AuthAPI.verifyOtp(email!, _otpController.text).then((value) {
                  Navigator.pushReplacementNamed(context, '/login');
                });
              },
              child: const Text('Xác thực'),
            ),
          ],
        ),
      ),
    );
  }
}

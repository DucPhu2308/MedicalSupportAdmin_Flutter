import 'package:bt_flutter/api/auth_api.dart';
import 'package:bt_flutter/layouts/default_layout_log_reg.dart';
import 'package:bt_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                  'NHẬP MÃ OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(controller: _otpController, label: 'Nhập mã OTP'),
                ElevatedButton(
                  onPressed: () {
                    AuthAPI.verifyOtp(email!, _otpController.text)
                        .then((value) {
                      if (value['statusCode'] == 400) {
                        Fluttertoast.showToast(
                          msg: 'Mã OTP không đúng',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }
                      Navigator.pushReplacementNamed(context, '/login');
                    });
                  },
                  child: const Text('Xác thực'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

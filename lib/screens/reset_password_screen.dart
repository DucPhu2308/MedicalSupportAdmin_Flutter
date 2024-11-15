import 'package:bt_flutter/api/auth_api.dart';
import 'package:bt_flutter/layouts/default_layout_log_reg.dart';
import 'package:bt_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                  'ĐỔI MẬT KHẨU',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(controller: _otpController, label: 'Nhập mã OTP'),
                MyTextField(
                    controller: _passwordController,
                    label: 'Mật khẩu mới',
                    isPassword: true),
                MyTextField(
                    controller: _confirmPasswordController,
                    label: 'Xác nhận mật khẩu mới',
                    isPassword: true),
                ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      Fluttertoast.showToast(
                        msg: 'Mật khẩu không khớp',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }
                    try {
                      AuthAPI.resetPassword(email!, _passwordController.text,
                              _otpController.text)
                          .then((value) {
                        if (value is! String && value['statusCode'] == 400) {
                          Fluttertoast.showToast(
                            msg: 'Mã OTP không đúng',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Đổi mật khẩu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

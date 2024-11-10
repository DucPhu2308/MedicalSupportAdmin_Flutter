import 'package:bt_flutter/api/auth_api.dart';
import 'package:bt_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    // Giải phóng các controller khi không còn cần thiết
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            MyTextField(
                label: 'Họ và tên đệm', controller: _firstNameController),
            MyTextField(label: 'Tên', controller: _lastNameController),
            MyTextField(label: 'Email', controller: _emailController),
            MyTextField(
              label: 'Mật khẩu',
              controller: _passwordController,
              isPassword: true,
            ),
            MyTextField(
              label: 'Xác nhận mật khẩu',
              controller: _confirmPasswordController,
              isPassword: true,
            ),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Vui lòng nhập đầy đủ thông tin',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  return;
                }
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  Fluttertoast.showToast(
                    msg: 'Mật khẩu không khớp',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  return;
                }
                AuthAPI.register(
                  _emailController.text,
                  _passwordController.text,
                  _firstNameController.text,
                  _lastNameController.text,
                ).then((value) => {
                      Fluttertoast.showToast(
                        msg: 'Đăng ký thành công',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      ),
                      Navigator.pushNamed(context, '/otp',
                          arguments: _emailController.text),
                    });
              },
              child: const Text('Đăng ký'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Đã có tài khoản? Đăng nhập ngay'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        obscureText: isPassword, // Ẩn mật khẩu nếu là trường password
      ),
    );
  }
}

import 'package:bt_flutter/screens/forgot_password_screen.dart';
import 'package:bt_flutter/screens/home_screen.dart';
import 'package:bt_flutter/screens/intro_screen.dart';
import 'package:bt_flutter/screens/login_screen.dart';
import 'package:bt_flutter/screens/otp_screen.dart';
import 'package:bt_flutter/screens/register_screen.dart';
import 'package:bt_flutter/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroScreen(),
      routes: Map<String, WidgetBuilder>.from({
        '/intro': (context) => const IntroScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/otp': (context) => const OtpScreen(),
        '/home': (context) => const HomeScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      }),
    );
  }
}

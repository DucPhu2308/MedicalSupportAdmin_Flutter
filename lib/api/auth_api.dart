import 'dart:convert';

import 'package:bt_flutter/api/base_api.dart';
import 'package:http/http.dart' as http;

class AuthAPI extends BaseApi {
  static Future login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/auth/login'),
        body: {
          'email': email,
          'password': password,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/auth/register'),
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/auth/verify'),
        body: {
          'email': email,
          'activeCode': otp,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/auth/forgot-password'),
        body: {
          'email': email,
        },
      );
      if (response.body.startsWith('{')) {
        return json.decode(response.body);
      }
      return response.body;
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future resetPassword(String email, String password, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/auth/reset-password'),
        body: {
          'email': email,
          'password': password,
          'activeCode': otp,
        },
      );
      if (response.body.startsWith('{')) {
        return json.decode(response.body);
      }
      return response.body;
    } catch (e) {
      print("Error: $e");
    }
  }
}

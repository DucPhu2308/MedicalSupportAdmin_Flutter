import 'base_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DoctorApi extends BaseApi {
  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      throw Exception('Token not found. Please log in again.');
    }
    return token;
  }
  static Future getAllDoctorInfo() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApi.baseUrl}/doctor/all'),
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future grantDoctorPermission(String doctorId) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('${BaseApi.baseUrl}/doctor/update/permissionDoctor'),
        body: json.encode({
          'doctorId': doctorId,
          'isPermission': true
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future removeDoctorPermission(String doctorId) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('${BaseApi.baseUrl}/doctor/update/permissionDoctor'),
        body: json.encode({
          'doctorId': doctorId,
          'isPermission': false
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }
}
import 'base_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DepartmentApi extends BaseApi {
  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      throw Exception('Token not found. Please log in again.');
    }
    return token;
  }

  static Future getAllDepartments() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${BaseApi.baseUrl}/department/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load departments: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  static Future addDepartment(String name) async {
    try {
      final token = await _getToken();
      print('Token: $token');
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/department/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
        }),
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add department: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  static Future updateDepartmentName(
      String departmentId, String newName) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('${BaseApi.baseUrl}/department/update/$departmentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': newName,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update department: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  static Future<void> deleteDepartment(String departmentId) async {
    try {
      print('departmentId: $departmentId');
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('${BaseApi.baseUrl}/department/delete/$departmentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody.containsKey('error')) {
          throw Exception(responseBody['error']);
        }

        return responseBody;
      } else {
        throw Exception('Failed to delete department: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }
}

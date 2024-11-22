import 'base_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorApi extends BaseApi {
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
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/ddoctor/update/permissionDoctor'),
        body: {
          'doctorId': doctorId,
          'isPermission': true.toString(),
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future removeDoctorPermission(String doctorId) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/doctor/update/permissionDoctor'),
        body: {
          'doctorId': doctorId,
          'isPermission': false.toString(),
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }
}
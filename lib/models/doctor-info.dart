import 'package:bt_flutter/models/speciality.dart';

class DoctorInfo {
  List<Speciality>? specialities;
  String phone;
  bool isPermission;

  DoctorInfo({this.specialities, required this.phone, this.isPermission = false});

  DoctorInfo.fromJson(Map<String, dynamic> json)
      : specialities = (json['specialities'] as List<dynamic>?)
            ?.map((e) => Speciality.fromJson(e))
            .toList(),
        phone = json['phone'],
        isPermission = json['isPermission'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'specialities': specialities?.map((e) => e.toJson()).toList(),
      'phone': phone,
      'isPermission': isPermission,
    };
  }
}
import 'package:bt_flutter/models/doctor-info.dart';

class User {
  String? id;
  String firstName;
  String lastName;
  String email;
  bool isActive;
  List<String> roles;
  DateTime createdAt;
  DateTime updatedAt;
  DoctorInfo? doctorInfo;
  String? avatar;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isActive,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    this.doctorInfo,
    this.avatar,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        isActive = json['isActive'],
        roles = List<String>.from(json['roles']),
        avatar = json['avatar'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']);
        

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'isActive': isActive,
        'roles': roles,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'avatar': avatar,
      };
}

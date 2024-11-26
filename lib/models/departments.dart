class Department {
  String id;
  String name;
  String createdAt;
  String updatedAt;
  int version;

  Department({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['_id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
    };
  }
}

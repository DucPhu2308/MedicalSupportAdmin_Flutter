class Speciality {
  final String name;

  Speciality({required this.name});

  Speciality.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
  
}
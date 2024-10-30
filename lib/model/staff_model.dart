class Staff {
  final String id;
  final String name;
  final String email;
  final String phone;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  // Factory constructor to handle Firestore data with correct casting
  factory Staff.fromMap(Map<String, dynamic> map, String id) {
    return Staff(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

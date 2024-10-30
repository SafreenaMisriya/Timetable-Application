class Subject {
  final String? id;
  final String name;
  final String courseId;
  final String staff;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subject({
    this.id,
    required this.name,
    required this.courseId,
    required this. staff,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'courseId': courseId,
      'staff': staff,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Subject.fromMap(String id, Map<String, dynamic> map) {
    return Subject(
      id: id,
      name: map['name'] ?? '',
      courseId: map['courseId'] ?? '',
      staff: map['staff'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
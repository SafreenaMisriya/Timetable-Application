class Course {
  String? id;
  String name;
  String description;
  List<String> subjectIds;
  DateTime createdAt;
  DateTime updatedAt;

  Course({
    this.id,
    required this.name,
    required this.description,
    List<String>? subjectIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : subjectIds = subjectIds ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'subjectIds': subjectIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Course.fromMap(String id, Map<String, dynamic> map) {
    return Course(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      subjectIds: List<String>.from(map['subjectIds'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

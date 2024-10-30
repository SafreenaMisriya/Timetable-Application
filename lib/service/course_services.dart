

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course_model.dart';

class CourseService {
  final CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection('courses');

  Future<String> createCourse(Course course) async {
    try {
      final docRef = await coursesCollection.add(course.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Stream<List<Course>> getCourses() {
    return coursesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Course.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  Future<Course?> getCourse(String id) async {
    try {
      final doc = await coursesCollection.doc(id).get();
      if (doc.exists) {
        return Course.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get course: $e');
    }
  }
  Future<void> updateCourse(String id, Course course) async {
    try {
      await coursesCollection.doc(id).update(course.toMap());
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await coursesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/subject_model.dart';

class SubjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'subjects';

  Future<String> createSubject(Subject subject) async {
    try {
      final docRef = await _firestore.collection(collectionName).add(subject.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create subject: $e');
    }
  }

  Stream<List<Subject>> getSubjectsForCourse(String courseId) {
    return _firestore
        .collection(collectionName)
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Subject.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> updateSubject(String id, Subject subject) async {
    try {
      await _firestore.collection(collectionName).doc(id).update(subject.toMap());
    } catch (e) {
      throw Exception('Failed to update subject: $e');
    }
  }

  Future<void> deleteSubject(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete subject: $e');
    }
  }
}
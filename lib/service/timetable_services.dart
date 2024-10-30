
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timetable_application/model/subject_model.dart';
import 'package:uuid/uuid.dart';

import '../model/timetable_model.dart';

class TimetableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'timetables';
  final uuid = const Uuid();


  Stream<List<Subject>> getSubjectsForCourse(String courseId) {
    return _firestore
        .collection('subjects')
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Subject.fromMap(doc.id, doc.data()))
            .toList());
  }


  List<TimetableEntry> generateWeeklyTimetable(List<Subject> subjects) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    const periodsPerDay = 4;
    final timetable = <TimetableEntry>[];

    for (int day = 0; day < 5; day++) {
      for (int period = 0; period < periodsPerDay; period++) {
        final randomIndex = Random().nextInt(subjects.length);
        timetable.add(
          TimetableEntry(
            id: uuid.v4(),
            day: weekDays[day],
            period: period + 1,
            subject: subjects[randomIndex].name,
            startTime: '${9 + period}:00 AM',
            endTime: '${10 + period}:00 AM',
          ),
        );
      }
    }

    return timetable;
  }

  Future<List<TimetableEntry>> generateTimetable(List<Subject> subjects) async {
    try {
      final entries = generateWeeklyTimetable(subjects);
      await _firestore.collection(collectionName).add({
        'entries': entries.map((entry) => entry.toMap()).toList(),
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      return entries; 
    } catch (e) {
      throw Exception('Failed to generate timetable: $e');
    }
  }
}
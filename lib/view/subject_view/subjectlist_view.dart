// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timetable_application/view/subject_view/create_subjects.dart';
import 'package:timetable_application/view/subject_view/widget/subject_card.dart';
import '../../model/subject_model.dart';
import '../../service/subject_services.dart';

class SubjectListScreen extends StatelessWidget {
  final String courseId;
  final String courseName;
  final SubjectService _subjectService = SubjectService();

  SubjectListScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subjects - $courseName',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.red,
            ),
            onPressed: () => _navigateToAddSubject(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Subject>>(
        stream: _subjectService.getSubjectsForCourse(courseId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final subjects = snapshot.data ?? [];

          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return SubjectCard(
                subject: subject,
                onEdit: () => _navigateToEditSubject(context, subject),
                onDelete: () => _deleteSubject(context, subject),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToAddSubject(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectFormScreen(courseId: courseId),
      ),
    );
  }

  void _navigateToEditSubject(BuildContext context, Subject subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectFormScreen(
          courseId: courseId,
          subject: subject,
        ),
      ),
    );
  }

  Future<void> _deleteSubject(BuildContext context, Subject subject) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Are you sure you want to delete ${subject.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _subjectService.deleteSubject(subject.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject deleted successfully',),backgroundColor: Colors.red,),
      );
    }
  }
}

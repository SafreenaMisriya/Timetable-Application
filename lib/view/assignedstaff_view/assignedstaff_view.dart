import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/staff_model.dart';
import '../../model/subject_model.dart';
import '../../service/subject_services.dart';

class AssignedstaffView extends StatefulWidget {
  final String courseId;

  const AssignedstaffView({super.key, required this.courseId});

  @override
  State<AssignedstaffView> createState() => _AssignedstaffViewState();
}

class _AssignedstaffViewState extends State<AssignedstaffView> {
  final SubjectService _subjectService = SubjectService();
  Map<String, String> _staffMap = {}; 
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadStaffMap();
  }

  Future<void> _loadStaffMap() async {
    _staffMap = await getStaffMap();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<Subject>>(
      stream: _subjectService.getSubjectsForCourse(widget.courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No subjects found for this course.'));
        } else {
          final subjects = snapshot.data!;

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('SUBJECT NAME'),
                          Text('ASSIGNED STAFF'),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      final staffName = _staffMap[subject.staff] ?? 'Unknown';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.teal[200]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(subject.name),
                              Text(staffName),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, String>> getStaffMap() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('staff').get();
    final staffMap = <String, String>{};

    for (var doc in snapshot.docs) {
      final staff = Staff.fromMap(doc.data(), doc.id);
      staffMap[staff.id] = staff.name;
    }
    return staffMap;
  }
}

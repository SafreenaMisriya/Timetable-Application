
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timetable_application/view/course_view/create_course.dart';
import '../../model/course_model.dart';
import '../../service/course_services.dart';
import '../subject_view/subjectlist_view.dart';

class CourseListScreen extends StatelessWidget {
  final CourseService _courseService = CourseService();

  CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Courses',style: Theme.of(context).textTheme.titleMedium,),
        automaticallyImplyLeading: false,
        leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
              centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add,color: Colors.red,),
            onPressed: () => _navigateToAddCourse(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Course>>(
        stream: _courseService.getCourses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final courses = snapshot.data ?? [];

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal)
                  ),
                  child: ListTile(
                    title: Text(course.name,style: Theme.of(context).textTheme.titleMedium,),
                    subtitle: Text(course.description),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _navigateToEditCourse(context, course);
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, course);
                        }
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectListScreen(
                          courseId: course.id!,
                          courseName: course.name,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToAddCourse(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CourseFormScreen(),
      ),
    );
  }

  void _navigateToEditCourse(BuildContext context, Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseFormScreen(course: course),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete ${course.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text('Cancel',style: Theme.of(context).textTheme.titleMedium,),
          ),
          TextButton(
            onPressed: () async {
              await _courseService.deleteCourse(course.id!);
              Navigator.pop(context);
            },
             style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete',),
          ),
        ],
      ),
    );
  }
}
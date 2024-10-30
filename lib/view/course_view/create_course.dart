// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timetable_application/widget/customtextformfield.dart';
import 'package:timetable_application/widget/cutom_botton.dart';
import '../../model/course_model.dart';
import '../../service/course_services.dart';

class CourseFormScreen extends StatefulWidget {
  final Course? course;

  const CourseFormScreen({super.key, this.course});

  @override
  // ignore: library_private_types_in_public_api
  _CourseFormScreenState createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseService = CourseService();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.course?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
              centerTitle: true,
        title: Text(widget.course == null ? 'Add Course' : 'Edit Course',style: Theme.of(context).textTheme.titleMedium,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Course Name',
                validator:(value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                controller: _descriptionController,
                hintText: 'Description',
                validator:(value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                }, 
                maxLines: 3,
              ),
              const SizedBox(height: 100),
              labelwidget(labelText:  widget.course == null ? 'Add Course' : 'Update Course', onTap: _saveCourse)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: widget.course?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        subjectIds: widget.course?.subjectIds ?? [],
        createdAt: widget.course?.createdAt,
      );

      try {
        if (widget.course == null) {
          await _courseService.createCourse(course);
        } else {
          await _courseService.updateCourse(course.id!, course);
        }
         ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Course Added Successfully'),backgroundColor: Colors.green,),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving course: $e'),backgroundColor: Colors.red,),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

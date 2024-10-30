// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timetable_application/widget/customtextformfield.dart';
import 'package:timetable_application/widget/cutom_botton.dart';
import '../../model/staff_model.dart';
import '../../model/subject_model.dart';
import '../../service/staff_services.dart';
import '../../service/subject_services.dart';

class SubjectFormScreen extends StatefulWidget {
  final String courseId;
  final Subject? subject;

  const SubjectFormScreen({
    super.key,
    required this.courseId,
    this.subject,
  });

  @override
  _SubjectFormScreenState createState() => _SubjectFormScreenState();
}

class _SubjectFormScreenState extends State<SubjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectService = SubjectService();
  final _staffService = StaffService();

  late TextEditingController _nameController;
  String? _selectedStaffId; 

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    if (widget.subject?.staff.isNotEmpty ?? false) {
      _selectedStaffId = widget.subject!.staff;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        title: Text(widget.subject == null ? 'Add Subject' : 'Edit Subject',style: const TextStyle(fontSize: 18),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Subject Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<Staff>>(
                stream: _staffService.getAllStaff(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final staffList = snapshot.data ?? [];

                  if (staffList.isEmpty) {
                    return const Text('No staff members available');
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedStaffId,
                    
                    decoration: const InputDecoration(
                      labelText:  'Assign Staff',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                      
                        borderSide: BorderSide(
                          color: Colors.teal,
                          width: 1,
                        ),
                      ),
                    ),
                    items: staffList.map((staff) {
                      return DropdownMenuItem<String>(
                        value: staff.id,
                        child: Text(staff.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a staff member';
                      }
                      return null;
                    },
                    onChanged: (String? value) {
                      setState(() {
                        _selectedStaffId = value;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 100),
              labelwidget(labelText:  widget.subject == null ? 'Add Subject' : 'Update Subject', onTap: _saveSubject)
           
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSubject() async {
    if (_formKey.currentState!.validate()) {
      try {
        final subject = Subject(
          id: widget.subject?.id,
          name: _nameController.text,
          courseId: widget.courseId,
          staff: _selectedStaffId != null ? _selectedStaffId! : '',
        );

        if (widget.subject == null) {
          await _subjectService.createSubject(subject);
        } else {
          await _subjectService.updateSubject(widget.subject!.id!, subject);
        }

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.subject == null
                ? 'Subject added successfully'
                : 'Subject updated successfully'),
                backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'),backgroundColor: Colors.red,),
        );
      }
    }
  }
}

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timetable_application/widget/cutom_botton.dart';

import '../../model/staff_model.dart';
import '../../service/staff_services.dart';
import '../../widget/customtextformfield.dart';

class StaffFormScreen extends StatefulWidget {
  final Staff? staff;

  const StaffFormScreen({super.key, this.staff});

  @override
  _StaffFormScreenState createState() => _StaffFormScreenState();
}

class _StaffFormScreenState extends State<StaffFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _staffService = StaffService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff?.name ?? '');
    _emailController = TextEditingController(text: widget.staff?.email ?? '');
    _phoneController = TextEditingController(text: widget.staff?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
        title: Text(widget.staff == null ? 'Add Staff' : 'Edit Staff',style: Theme.of(context).textTheme.titleMedium,),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Staff Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter staff name'
                    : null,
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                controller: _phoneController,
                maxLength: 10,
                keyboardType: const TextInputType.numberWithOptions(),
                hintText: 'Phone Number',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Phone Number'
                    : null,
              ),
              const SizedBox(height: 100),
              Center(child: 
              labelwidget(labelText: widget.staff == null ? 'Add Staff' : 'Update Staff', onTap: _saveStaff),)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveStaff() async {
    if (_formKey.currentState!.validate()) {
      final staff = Staff(
        id: widget.staff?.id ?? '',
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      try {
        if (widget.staff == null) {
          await _staffService.createStaff(staff);
        } else {
          await _staffService.updateStaff(widget.staff!.id, staff);
        }
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.staff == null
                ? 'Staff added successfully'
                : 'Staff updated successfully'),
                backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'),backgroundColor:Colors.red ,),
          
        );
      }
    }
  }
}

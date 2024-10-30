
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timetable_application/view/staff_view/create_staff.dart';
import 'package:timetable_application/view/staff_view/widget/staff_card.dart';
import '../../model/staff_model.dart';
import '../../service/staff_services.dart';

class StaffListScreen extends StatelessWidget {
  final StaffService _staffService = StaffService();

  StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Management',style: Theme.of(context).textTheme.titleMedium,),
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
            onPressed: () => _navigateToAddStaff(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Staff>>(
        stream: _staffService.getAllStaff(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final staffList = snapshot.data ?? [];

          if (staffList.isEmpty) {
            return const Center(
              child: Text('No staff members found'),
            );
          }

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              return StaffCard(
                staff: staff,
                onEdit: () => _navigateToEditStaff(context, staff),
                onDelete: () => _deleteStaff(context, staff),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToAddStaff(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const StaffFormScreen()));
  }

  void _navigateToEditStaff(BuildContext context, Staff staff) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>StaffFormScreen(staff: staff,)));
  }

  Future<void> _deleteStaff(BuildContext context, Staff staff) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Staff'),
        content: Text('Are you sure you want to delete ${staff.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text('Cancel',style: Theme.of(context).textTheme.titleMedium,),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _staffService.deleteStaff(staff.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff member deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting staff member: $e')),
        );
      }
    }
  }
}
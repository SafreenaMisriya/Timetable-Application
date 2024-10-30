import 'package:flutter/material.dart';
import 'package:timetable_application/view/assignedstaff_view/assignedstaff_view.dart';
import 'package:timetable_application/view/timetable_view/timetable_view.dart';

class TabView extends StatelessWidget {
  final String courseId;
  const TabView({super.key, required this.courseId});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            'Timetable And Assigned Staff',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelStyle: TextStyle(color: Colors.black),
            indicatorColor: Colors.teal,
            dividerColor: Colors.white,
            tabs: [
              Tab(
                text: 'Timetable',
              ),
              Tab(text: 'Assigned Staff'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TimetableScreen(courseId: courseId),
            AssignedstaffView(
              courseId: courseId,
            ),
          ],
        ),
      ),
    );
  }
}

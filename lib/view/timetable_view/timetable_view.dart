// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../model/subject_model.dart';
import '../../model/timetable_model.dart';
import '../../service/timetable_services.dart';
import '../../widget/mediaquery.dart';
class TimetableScreen extends StatefulWidget {
  final String courseId;

  const TimetableScreen({super.key, required this.courseId});

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late final TimetableService _timetableService;
  List<TimetableEntry> _timetable = [];
  late List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _timetableService = TimetableService();
    _loadSubjects();
  }

  void _loadSubjects() {
    _timetableService.getSubjectsForCourse(widget.courseId).listen((subjects) {
      setState(() {
        _subjects = subjects;
        _generateTimetable();
      });
    });
  }

  void _generateTimetable() async {
    if (_subjects.isNotEmpty) {
      List<TimetableEntry> timetableEntries =
          await _timetableService.generateTimetable(_subjects);
      setState(() {
        _timetable = timetableEntries;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(mediaquerywidth(0.02, context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              defaultColumnWidth: FixedColumnWidth(mediaquerywidth(0.18, context)),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.orange[200]),
                  children: [
                    buildTableCell(context, 'Day', fontWeight: FontWeight.bold),
                    buildTableCell(context, 'Period 1', fontWeight: FontWeight.bold),
                    buildTableCell(context, 'Period 2', fontWeight: FontWeight.bold),
                    buildTableCell(context, 'Period 3', fontWeight: FontWeight.bold),
                    buildTableCell(context, 'Period 4', fontWeight: FontWeight.bold),
                  ],
                ),
                ..._buildTimetableRows(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildTimetableRows(BuildContext context) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final tableRows = <TableRow>[];
    
    for (var day in weekDays) {
      final entriesForDay = _timetable.where((entry) => entry.day == day).toList();
      final periodCells = <Widget>[];

      for (int period = 1; period <= 4; period++) {
        final entry = entriesForDay.firstWhere(
          (entry) => entry.period == period,
          orElse: () => TimetableEntry(
            id: '',
            day: day,
            period: period,
            subject: '-',
            startTime: '',
            endTime: '',
          ),
        );
        
        periodCells.add(
          Container(
            height: mediaqueryheight(0.1, context),
            padding: EdgeInsets.all(mediaquerywidth(0.02, context)),
            margin: EdgeInsets.all(mediaquerywidth(0.005, context)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(mediaquerywidth(0.01, context)),
            ),
            child: Center(
              child: Text(
                entry.subject,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: mediaquerywidth(0.035, context),
                ),
              ),
            ),
          ),
        );
      }

      tableRows.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.orange[200]),
          children: [
            Container(
              height: mediaqueryheight(0.1, context),
              padding: EdgeInsets.all(mediaquerywidth(0.02, context)),
              margin: EdgeInsets.all(mediaquerywidth(0.005, context)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(mediaquerywidth(0.01, context)),
              ),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: mediaquerywidth(0.035, context),
                  ),
                ),
              ),
            ),
            ...periodCells,
          ],
        ),
      );
    }
    return tableRows;
  }

  TableCell buildTableCell(
    BuildContext context,
    String text, {
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return TableCell(
      child: Container(
        height: mediaqueryheight(0.1, context),
        padding: EdgeInsets.all(mediaquerywidth(0.02, context)),
        margin: EdgeInsets.all(mediaquerywidth(0.005, context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(mediaquerywidth(0.01, context)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: fontWeight,
              color: Colors.black,
              fontSize: mediaquerywidth(0.035, context),
            ),
          ),
        ),
      ),
    );
  }
}
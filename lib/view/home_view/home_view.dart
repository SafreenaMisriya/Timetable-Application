import 'package:flutter/material.dart';
import '../../widget/mediaquery.dart';
import '../course_view/listofcourse.dart';
import '../staff_view/stafflist_view.dart';
import 'widget/gridview_widget.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final double stackHeight = isLandscape 
        ? mediaqueryheight(0.6, context)
        : mediaqueryheight(0.3, context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Timetable Application',
          style: TextStyle(
            fontSize: mediaquerywidth(0.05, context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: stackHeight,
              child: Stack(
                children: [
                  Container(
                    height: stackHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        'https://img.freepik.com/premium-vector/students-immerse-themselves-books-sharing-insights-ideas-colorful-learning-environment-education-learning-concept-likes-read-people-read-students-study_538213-157433.jpg?semt=ais_hybrid',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: mediaquerywidth(0.05, context),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaquerywidth(0.04, context),
                        vertical: mediaqueryheight(0.015, context),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseListScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: mediaquerywidth(0.08, context),
                                    color: Colors.orange,
                                  ),
                                  SizedBox(height: mediaqueryheight(0.01, context)),
                                  Text(
                                    'Course',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontSize: mediaquerywidth(0.04, context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: mediaqueryheight(0.05, context),
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaffListScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: mediaquerywidth(0.08, context),
                                    color: Colors.orange,
                                  ),
                                  SizedBox(height: mediaqueryheight(0.01, context)),
                                  Text(
                                    'Staff',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontSize: mediaquerywidth(0.04, context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mediaqueryheight(0.025, context)),
            gridview(),
          ],
        ),
      ),
    );
  }
}
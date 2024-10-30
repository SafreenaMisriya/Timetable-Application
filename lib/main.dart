import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timetable_application/firebase_options.dart';
import 'view/home_view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'DMSans',
          scaffoldBackgroundColor: Colors.white),
      home:const HomeScreen(),
    );
  }
}

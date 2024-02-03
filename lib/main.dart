import 'package:flutter/material.dart';
import 'package:voice_assistance_app/home_page.dart';
import 'package:voice_assistance_app/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jennie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          color: Pallete.whiteColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}



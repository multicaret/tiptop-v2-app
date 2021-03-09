import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/screens/splash_screen.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TipTop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        accentColor: AppColors.secondary,
      ),
      home: SplashScreen(),
    );
  }
}
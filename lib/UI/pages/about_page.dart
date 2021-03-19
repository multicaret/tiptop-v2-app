import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('About Page'),
      ),
    );
  }
}

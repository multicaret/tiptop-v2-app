import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash-bg.png"),
            alignment: Alignment.bottomCenter,
          )
        ),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.2),
            Image.asset(
              'assets/images/tiptop-logo.png',
              width: screenSize.width / 2.5,
            ),
          ],
        ),
      )
    );
  }
}

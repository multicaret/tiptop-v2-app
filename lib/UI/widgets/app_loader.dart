import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoader extends StatelessWidget {
  final double width;

  const AppLoader({
    this.width = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Lottie.asset('assets/images/lottie-loader/data.json'),
    );
  }
}

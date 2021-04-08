import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class NoContentView extends StatelessWidget {
  final String text;

  NoContentView({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: screenHorizontalPadding),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(text),
            const SizedBox(height: 15),
            Image.asset('assets/images/empty_products.png'),
          ],
        ),
      ),
    );
  }
}

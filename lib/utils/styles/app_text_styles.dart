import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle h2 = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle body = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text50,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static TextStyle dynamicValues({
    Color color = AppColors.text50,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    String family = 'NeoSansArabic',
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontFamily: family,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
    );
  }
}

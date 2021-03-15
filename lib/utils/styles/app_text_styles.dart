import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 28,
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

  static const TextStyle h2White = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle h3White = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle body = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyWhite = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyWhiteBold = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitle = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXs = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitle50 = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text50,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleBold = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyBold = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyBoldSecondaryDark = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.secondaryDark,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodySecondary = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.secondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodySecondaryDark = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.secondaryDark,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleWhite = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleWhiteBold = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );


  static const TextStyle subtitleXsWhiteBold = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle button = const TextStyle(
    fontFamily: 'NeoSansArabic',
    color: AppColors.white,
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

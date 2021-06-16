import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = const TextStyle(
    color: AppColors.text,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle h2 = const TextStyle(
    color: AppColors.text,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle h2White = const TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle h2Secondary = const TextStyle(
    color: AppColors.secondary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle h3White = const TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle body = const TextStyle(
    color: AppColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle body50 = const TextStyle(
    color: AppColors.text50,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyWhite = const TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyWhiteBold = const TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitle = const TextStyle(
    color: AppColors.text,
    fontSize: 14,
    height: 1,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle subtitleSecondary = const TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleSecondaryBold = const TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    height: 1,
  );

  static const TextStyle subtitleXs = const TextStyle(
    color: AppColors.text,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXsSecondary = const TextStyle(
    color: AppColors.secondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXxsWhite = const TextStyle(
    color: AppColors.white,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXxsSecondary = const TextStyle(
    color: AppColors.secondary,
    fontSize: 10,
    height: 1,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXxsSecondaryBold = const TextStyle(
    color: AppColors.secondary,
    fontSize: 10,
    height: 1,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXsBold = const TextStyle(
    color: AppColors.text,
    fontSize: 12,
    height: 1,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle subtitle50 = const TextStyle(
    color: AppColors.text50,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXs50 = const TextStyle(
    color: AppColors.text50,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXxs50 = const TextStyle(
    color: AppColors.text50,
    fontSize: 10,
    height: 1,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleBold = const TextStyle(
    color: AppColors.text,
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyBold = const TextStyle(
    color: AppColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyBoldSecondaryDark = const TextStyle(
    color: AppColors.secondary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodySecondary = const TextStyle(
    color: AppColors.secondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodySecondaryDark = const TextStyle(
    color: AppColors.secondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleWhite = const TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleWhite50 = const TextStyle(
    color: AppColors.white50,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleWhiteBold = const TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXsWhite = const TextStyle(
    color: AppColors.white,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle subtitleXsWhiteBold = const TextStyle(
    color: AppColors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle button = const TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle textButton = const TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static Style htmlXsBold = Style(
    color: AppColors.text,
    fontSize: FontSize(12),
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    textAlign: TextAlign.end,
  );

  static TextStyle dynamicValues({
    Color color = AppColors.text50,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    String family = 'NeoSansArabic',
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
    double height = 1.2,
  }) {
    return TextStyle(
      fontFamily: family,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      height: height,
    );
  }
}

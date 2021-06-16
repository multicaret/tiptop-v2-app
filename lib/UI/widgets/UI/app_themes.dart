import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppThemes {
  static ThemeData mainTheme(bool isRTL, bool isKurdish) {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      accentColor: AppColors.secondaryLight,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily,
      textTheme: TextTheme(
        headline1: AppTextStyles.h2.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
        button: AppTextStyles.button.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
        bodyText1: AppTextStyles.body.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
        bodyText2: AppTextStyles.body.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily), //Default style everywhere, e.g. Text widget
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        textTheme: TextTheme(
          headline1: AppTextStyles.h2.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
          headline6: AppTextStyles.h2.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
          bodyText1: AppTextStyles.body.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
        ),
        iconTheme: IconThemeData(color: AppColors.primary, size: 20),
        actionsIconTheme: IconThemeData(color: AppColors.primary, size: 20),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          minimumSize: Size.fromHeight(55),
          textStyle: AppTextStyles.button.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
          elevation: 4,
          shadowColor: AppColors.shadowDark,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        showValueIndicator: ShowValueIndicator.onlyForContinuous,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 6.0),
        activeTickMarkColor: AppColors.primary,
        activeTrackColor: AppColors.primary,
        inactiveTickMarkColor: AppColors.primary50,
        inactiveTrackColor: AppColors.primary50,
        thumbColor: AppColors.primary,
        valueIndicatorColor: AppColors.secondary,
        disabledInactiveTrackColor: AppColors.primary50,
        disabledActiveTickMarkColor: AppColors.primary,
        disabledInactiveTickMarkColor: AppColors.primary50,
        disabledActiveTrackColor: AppColors.primary,
        disabledThumbColor: AppColors.primary,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        primary: AppColors.primary,
        textStyle: AppTextStyles.textButton.copyWith(fontFamily: isKurdish ? kurdishFontFamily : arabicAndEnglishFontFamily),
      )),
    );
  }
}

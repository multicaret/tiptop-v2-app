import 'package:flutter/cupertino.dart';

import 'app_colors.dart';

class AppIcon {
  static icon(IconData iconName) {
    return Icon(iconName, color: AppColors.text, size: 20);
  }

  static iconPrimary(IconData iconName) {
    return Icon(iconName, color: AppColors.primary, size: 20);
  }

  static iconMdPrimary(IconData iconName) {
    return Icon(iconName, color: AppColors.primary, size: 35);
  }

  static iconLgPrimary(IconData iconName) {
    return Icon(iconName, color: AppColors.primary, size: 50);
  }

  static iconSecondary(IconData iconName) {
    return Icon(iconName, color: AppColors.secondaryDark, size: 20);
  }

  static iconLgSecondary(IconData iconName) {
    return Icon(iconName, color: AppColors.secondaryDark, size: 50);
  }

  static icon50(IconData iconName) {
    return Icon(iconName, color: AppColors.text50, size: 20);
  }

  static iconWhite(IconData iconName) {
    return Icon(iconName, color: AppColors.white, size: 20);
  }

  static iconS50(IconData iconName) {
    return Icon(iconName, color: AppColors.text50, size: 16);
  }

  static iconLgWhite(IconData iconName) {
    return Icon(iconName, color: AppColors.white, size: 30);
  }

  static iconLg50(IconData iconName) {
    return Icon(iconName, color: AppColors.text50, size: 25);
  }

  static iconXs(IconData iconName) {
    return Icon(iconName, color: AppColors.text, size: 15);
  }

  static iconXsPrimary(IconData iconName) {
    return Icon(iconName, color: AppColors.primary, size: 15);
  }

  static iconXsWhite(IconData iconName) {
    return Icon(iconName, color: AppColors.white, size: 13);
  }

  static iconXsWhite50(IconData iconName) {
    return Icon(iconName, color: AppColors.white.withOpacity(0.5), size: 13);
  }
}

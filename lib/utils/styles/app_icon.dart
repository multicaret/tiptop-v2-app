import 'package:flutter/cupertino.dart';

import 'app_colors.dart';

class AppIcon {
  static icon(IconData iconName) {
    return Icon(iconName, color: AppColors.text, size: 20);
  }

  static iconSm(IconData iconName) {
    return Icon(iconName, color: AppColors.text, size: 14);
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

  static iconMdSecondary(IconData iconName) {
    return Icon(iconName, color: AppColors.secondaryDark, size: 30);
  }

  static iconLgSecondary(IconData iconName) {
    return Icon(iconName, color: AppColors.secondaryDark, size: 50);
  }

  static icon50(IconData iconName) {
    return Icon(iconName, color: AppColors.text50, size: 20);
  }

  static iconSm50(IconData iconName) {
    return Icon(iconName, color: AppColors.text50, size: 18);
  }

  static iconSmSecondary(IconData iconName) {
    return Icon(iconName, color: AppColors.secondaryDark, size: 18);
  }

  static iconWhite(IconData iconName) {
    return Icon(iconName, color: AppColors.white, size: 20);
  }

  static iconMdWhite(IconData iconName) {
    return Icon(iconName, color: AppColors.white, size: 25);
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
    return Icon(iconName, color: AppColors.text, size: 14);
  }

  static iconXsPrimary(IconData iconName) {
    return Icon(iconName, color: AppColors.primary, size: 14);
  }

  static iconXsSecondary(IconData iconName) {
    return Icon(iconName, color: AppColors.secondaryDark, size: 14);
  }

  static iconXs50(IconData iconName) {
    return Icon(iconName, color: AppColors.primary50, size: 14);
  }

  static iconXsWhite(IconData iconName) {
    return Icon(iconName, color: AppColors.white, size: 14);
  }

  static iconXsWhite50(IconData iconName) {
    return Icon(iconName, color: AppColors.white.withOpacity(0.5), size: 14);
  }
}

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppButtons {
  static dynamic({
    Function onPressed,
    Widget child,
    Color textColor = AppColors.white,
    Color bgColor = AppColors.primary,
    double height = 55,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        onPrimary: textColor,
        minimumSize: Size.fromHeight(height),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  static primary({Function onPressed, Widget child}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }

  static primaryXl({Function onPressed, Widget child}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(150)),
      onPressed: onPressed,
      child: child,
    );
  }

  static primarySm({Function onPressed, Widget child}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(45)),
      onPressed: onPressed,
      child: child,
    );
  }

  static secondary({Function onPressed, Widget child}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.secondary,
        onPrimary: AppColors.text,
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  static secondaryXl({Function onPressed, Widget child}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.secondary,
        onPrimary: AppColors.text,
        minimumSize: Size.fromHeight(150),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  static secondarySm({Function onPressed, Widget child}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.secondary,
        onPrimary: AppColors.text,
        minimumSize: Size.fromHeight(45),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

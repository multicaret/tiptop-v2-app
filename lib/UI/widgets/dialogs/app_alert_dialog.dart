import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppAlertDialog extends StatelessWidget {
  final List<Widget> children;

  AppAlertDialog({this.children});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.all(10),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

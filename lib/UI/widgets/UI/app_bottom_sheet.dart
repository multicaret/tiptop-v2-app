import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../bottom_sheet_indicator.dart';

class AppBottomSheet extends StatelessWidget {
  final double screenHeightFraction;
  final List<Widget> children;
  final String title;
  final Function clearAction;
  final Function applyAction;

  AppBottomSheet({
    @required this.screenHeightFraction,
    @required this.children,
    @required this.title,
    this.clearAction,
    this.applyAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * screenHeightFraction,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
        ),
      ),
      child: Column(
        children: [
          BottomSheetIndicator(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: clearAction == null ? 10 : 0),
            margin: EdgeInsets.only(top: 10, left: screenHorizontalPadding, right: screenHorizontalPadding, bottom: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Translations.of(context).get(title),
                  style: AppTextStyles.h2Secondary,
                ),
                if (clearAction != null)
                  TextButton(
                    onPressed: clearAction,
                    child: Center(child: Text(Translations.of(context).get('Clear'))),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
          if (applyAction != null)
            Padding(
              padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 20, bottom: 40),
              child: AppButtons.secondary(
                child: Text(Translations.of(context).get('Apply'), style: AppTextStyles.body),
                onPressed: applyAction,
              ),
            ),
        ],
      ),
    );
  }
}

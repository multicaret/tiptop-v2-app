import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppDropDownButton extends StatelessWidget {
  final int defaultValue;
  final List<Map<String, dynamic>> items;
  final Function onChanged;
  final String labelText;
  final String hintText;
  final bool fit;
  final bool isRequired;
  final bool isInvalid;

  AppDropDownButton({
    @required this.defaultValue,
    @required this.items,
    @required this.onChanged,
    this.labelText,
    this.hintText = '',
    this.fit = false,
    this.isRequired = false,
    this.isInvalid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: AppColors.bg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                text: TextSpan(
                  text: Translations.of(context).get(labelText),
                  style: AppTextStyles.bodyBold,
                  children: <TextSpan>[
                    if (isRequired) TextSpan(text: ' *', style: AppTextStyles.bodySecondary),
                  ],
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
            margin: EdgeInsets.only(bottom: fit || isInvalid ? 0 : 20),
            decoration: BoxDecoration(
              color: AppColors.bg,
              border: Border.all(color: isInvalid ? Colors.red : AppColors.border, width: isInvalid ? 1: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: defaultValue,
                icon: AppIcons.icon(FontAwesomeIcons.angleDown),
                style: AppTextStyles.body,
                onChanged: (newValue) => onChanged(newValue),
                itemHeight: 50,
                isExpanded: true,
                hint: hintText != null && hintText.isNotEmpty ? Text(hintText) : null,
                items: <Map<String, dynamic>>[...items].map<DropdownMenuItem<int>>(
                  (Map<String, dynamic> value) {
                    return DropdownMenuItem<int>(
                      value: value['id'],
                      child: value['title'] is Widget ? value['title'] : Text(value['title']),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          if (isInvalid)
            Padding(
              padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 10, bottom: 20),
              child: Text(
                Translations.of(context).get("This field is required"),
                style: AppTextStyles.subtitleXs.copyWith(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

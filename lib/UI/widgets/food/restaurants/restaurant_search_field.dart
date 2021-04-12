import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantSearchField extends StatelessWidget {
  final Function onTap;
  final Function onChanged;
  final Function onClear;
  final FocusNode focusNode;
  final bool showClearIcon;

  RestaurantSearchField({
    this.onTap,
    this.onChanged,
    this.onClear,
    this.controller,
    this.focusNode,
    this.showClearIcon,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [const BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: TextFormField(
        onTap: onTap,
        decoration: InputDecoration(
          hintText: 'What are you looking for?',
          hintStyle: AppTextStyles.body50,
          filled: true,
          prefixIcon: AppIcons.icon(FontAwesomeIcons.search),
          suffix: showClearIcon
              ? GestureDetector(
                  child: AppIcons.iconSm50(FontAwesomeIcons.solidTimesCircle),
                  onTap: onClear,
                )
              : null,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
        ),
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
      ),
    );
  }
}

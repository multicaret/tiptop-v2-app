import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantSearchField extends StatelessWidget {
  final Function onTap;

  RestaurantSearchField({this.onTap});

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
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  CategoryItem({
    @required this.imageUrl,
    @required this.title,
  });

  static double categoryItemHeight = 220;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 7,
                  color: AppColors.shadow,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: AppTextStyles.subtitleXs,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

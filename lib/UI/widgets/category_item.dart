import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/helper.dart';
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
        Container(
          width: double.infinity,
          height: getColItemHeight(4, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: AppColors.shadow,
              )
            ],
            image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 5),
        Expanded(
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

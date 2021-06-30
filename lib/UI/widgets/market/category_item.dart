import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cached_network_image.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  CategoryItem({
    @required this.imageUrl,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: getColItemHeight(4, context),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              const BoxShadow(
                blurRadius: 7,
                color: AppColors.shadow,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AppCachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: getColItemHeight(4, context),
            ),
          ),
        ),
        const SizedBox(height: 5),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: getColItemHeight(3, context),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: AppColors.primary),
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              image: CachedNetworkImageProvider(product.media.cover),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                product.title,
                style: AppTextStyles.subtitle,
              )
            ],
          ),
        )
      ],
    );
  }
}

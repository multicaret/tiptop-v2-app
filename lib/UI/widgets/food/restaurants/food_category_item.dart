import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodCategoryItem extends StatelessWidget {
  final Category category;
  final int index;
  final int count;
  final bool isRTL;
  final bool isSelectable;
  final Function onTap;
  final bool isSelected;

  const FoodCategoryItem({
    @required this.category,
    @required this.index,
    @required this.count,
    @required this.isRTL,
    this.isSelectable = false,
    this.onTap,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isRTL
          ? EdgeInsets.only(right: index == 0 ? screenHorizontalPadding : 0, left: index == count - 1 ? screenHorizontalPadding : 0)
          : EdgeInsets.only(left: index == 0 ? screenHorizontalPadding : 0, right: index == count - 1 ? screenHorizontalPadding : 0),
      child: InkWell(
        onTap: isSelectable
            ? onTap
            : () {
                Navigator.of(context, rootNavigator: true).pushNamed(RestaurantsPage.routeName);
              },
        child: Stack(
          children: [
            Container(
              width: 116,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    category.thumbnail,
                  ),
                ),
                color: AppColors.primary50,
              ),
            ),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, AppColors.primary], // red to yellow
                  ),
                ),
                child: Text(
                  category.title,
                  style: AppTextStyles.subtitleWhite,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            isSelected
                ? Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.secondary, width: 2),
                        color: AppColors.primary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppIcons.iconWhite(FontAwesomeIcons.check),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

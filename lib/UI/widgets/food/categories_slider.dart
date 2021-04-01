import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/food_category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class CategoriesSlider extends StatelessWidget {
  final List<Category> categories;
  final bool isRTL;
  final bool isCategorySelectable;

  CategoriesSlider({
    @required this.categories,
    @required this.isRTL,
    this.isCategorySelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
      color: AppColors.white,
      height: 110,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => FoodCategoryItem(
          category: categories[i],
          index: i,
          count: categories.length,
          isRTL: isRTL,
          isSelectable: isCategorySelectable,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/food_category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';

class CategoriesSlider extends StatelessWidget {
  final List<Category> categories;
  final bool isRTL;
  final Function setSelectedCategoryId;
  final int selectedCategoryId;

  CategoriesSlider({
    @required this.categories,
    @required this.isRTL,
    this.setSelectedCategoryId,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: restaurantCategoriesHeight,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => FoodCategoryItem(
          category: categories[i],
          index: i,
          count: categories.length,
          isRTL: isRTL,
          isSelectable: setSelectedCategoryId != null,
          onTap: () => setSelectedCategoryId(categories[i].id),
          isSelected: selectedCategoryId == categories[i].id,
        ),
      ),
    );
  }
}

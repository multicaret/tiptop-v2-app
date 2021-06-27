import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/food_category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';

class CategoriesSlider extends StatelessWidget {
  final List<Category> categories;
  final Function setSelectedCategories;
  final List<int> selectedCategories;
  final Function onCategoryTap;

  CategoriesSlider({
    @required this.categories,
    this.setSelectedCategories,
    this.selectedCategories,
    this.onCategoryTap,
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
        itemBuilder: (context, i) {
          bool isSelected = selectedCategories == null
              ? false
              : selectedCategories.firstWhere((categoryId) => categoryId == categories[i].id, orElse: () => null) != null;
          return FoodCategoryItem(
            category: categories[i],
            index: i,
            count: categories.length,
            onTap: () {
              if (onCategoryTap != null) {
                onCategoryTap(categories[i].title);
              } else if (setSelectedCategories == null) {
                pushCupertinoPage(
                  context,
                  RestaurantsPage(
                    selectedCategoryId: categories[i].id,
                  ),
                );
              } else {
                setSelectedCategories(categories[i].id);
              }
            },
            isSelected: isSelected,
          );
        },
      ),
    );
  }
}

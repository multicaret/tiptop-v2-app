import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/food_category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';

class CategoriesSlider extends StatelessWidget {
  final List<Category> categories;
  final bool isRTL;
  final Function setSelectedCategories;
  final List<int> selectedCategories;

  CategoriesSlider({
    @required this.categories,
    @required this.isRTL,
    this.setSelectedCategories,
    this.selectedCategories,
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
            isRTL: isRTL,
            onTap: () {
              if (setSelectedCategories == null) {
                Navigator.of(context, rootNavigator: true).pushNamed(RestaurantsPage.routeName, arguments: {
                  'selected_category_id': categories[i].id,
                });
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

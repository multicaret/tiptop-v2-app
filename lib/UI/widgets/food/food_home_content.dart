import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';


class FoodHomeContent extends StatelessWidget {
  final HomeData foodHomeData;
  final bool isRTL;

  FoodHomeContent({
    @required this.foodHomeData,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle('Categories'),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: AppColors.white,
          child: CategoriesSlider(categories: foodHomeData.categories, isRTL: isRTL),
        ),
        FilterSortButtons(foodCategories: foodHomeData.categories),
        RestaurantsIndex(restaurants: foodHomeData.restaurants),
      ],
    );
  }
}

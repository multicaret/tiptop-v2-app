import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

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
        CategoriesSlider(categories: foodHomeData.categories),
        FilterSortButtons(),
        RestaurantsIndex(restaurants: foodHomeData.restaurants),
        TextButton(
          onPressed: () => pushCupertinoPage(context, RestaurantsPage()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Translations.of(context).get("View All")),
              const SizedBox(width: 5),
              AppIcons.iconSm(isRTL ? FontAwesomeIcons.chevronLeft : FontAwesomeIcons.chevronRight),
            ],
          ),
        )
      ],
    );
  }
}

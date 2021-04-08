import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/horizontal_restaurant_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/vertical_restaurant_list_item.dart';
import 'package:tiptop_v2/dummy_data.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../filter_sort_buttons.dart';

class RestaurantsIndex extends StatefulWidget {
  @override
  _RestaurantsIndexState createState() => _RestaurantsIndexState();
}

class _RestaurantsIndexState extends State<RestaurantsIndex> {
  ListType activeListType = ListType.HORIZONTALLY_STACKED;

  final List<Map<String, dynamic>> _listTypes = [
    {
      'type': ListType.HORIZONTALLY_STACKED,
      'icon': 'assets/images/list-view-icon.png',
    },
    {
      'type': ListType.VERTICALLY_STACKED,
      'icon': 'assets/images/grid-view-icon.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterSortButtons(foodCategories: dummyFoodCategories),
        Padding(
          padding: const EdgeInsets.only(left: screenHorizontalPadding, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${Translations.of(context).get("Restaurants")} (${dummyRestaurants.length})', style: AppTextStyles.body50),
              Row(
                children: List.generate(
                  _listTypes.length,
                  (i) => Material(
                    color: AppColors.bg,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
                        child: Image.asset(
                          _listTypes[i]['icon'],
                          color: activeListType == _listTypes[i]['type'] ? AppColors.primary : AppColors.primary50,
                          width: 18,
                          height: 16,
                        ),
                      ),
                      onTap: () => setState(() => activeListType = _listTypes[i]['type']),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dummyRestaurants.length,
          itemBuilder: (c, i) => Material(
            color: AppColors.white,
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(RestaurantPage.routeName, arguments: dummyRestaurants[i]),
              child: activeListType == ListType.HORIZONTALLY_STACKED
                  ? HorizontalRestaurantListItem(restaurant: dummyRestaurants[i])
                  : VerticalRestaurantListItem(restaurant: dummyRestaurants[i]),
            ),
          ),
        ),
      ],
    );
  }
}

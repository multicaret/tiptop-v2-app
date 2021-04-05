import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/horizontal_restaurant_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/vertical_restaurant_list_item.dart';
import 'package:tiptop_v2/dummy_data.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodHomePage extends StatefulWidget {
  @override
  _FoodHomePageState createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
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
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 17.0, bottom: 5.0),
          child: Text(Translations.of(context).get("Categories"), style: AppTextStyles.body50),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: AppColors.white,
          child: CategoriesSlider(categories: dummyCategories, isRTL: appProvider.isRTL),
        ),
        FilterSortButtons(),
        Padding(
          padding: const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Translations.of(context).get("All Restaurants"), style: AppTextStyles.body50),
              Row(
                children: List.generate(
                  _listTypes.length,
                  (i) => InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: i == 0
                              ? appProvider.isRTL
                                  ? 0
                                  : 25
                              : 0,
                          left: i == 0
                              ? appProvider.isRTL
                                  ? 25
                                  : 0
                              : 0),
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

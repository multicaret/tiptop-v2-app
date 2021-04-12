import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/horizontal_restaurant_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/vertical_restaurant_list_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantsIndex extends StatelessWidget {
  final bool isFiltered;

  RestaurantsIndex({this.isFiltered = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (c, restaurantProvider, _) {
        List<Branch> restaurants = isFiltered ? restaurantProvider.filteredRestaurants : restaurantProvider.restaurants;
        List<Map<String, dynamic>> listTypes = restaurantProvider.listTypes;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: screenHorizontalPadding, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${Translations.of(context).get("Restaurants")} (${restaurants.length})', style: AppTextStyles.body50),
                  Row(
                    children: List.generate(
                      listTypes.length,
                      (i) => Material(
                        color: AppColors.bg,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
                            child: Image.asset(
                              listTypes[i]['icon'],
                              color: restaurantProvider.activeListType == listTypes[i]['type'] ? AppColors.primary : AppColors.primary50,
                              width: 18,
                              height: 16,
                            ),
                          ),
                          onTap: () => restaurantProvider.setActiveListType(listTypes[i]['type']),
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
              itemCount: restaurants.length,
              itemBuilder: (c, i) => Material(
                color: AppColors.white,
                child: InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                    RestaurantPage.routeName,
                    arguments: restaurants[i].id,
                  ),
                  child: restaurantProvider.activeListType == ListType.HORIZONTALLY_STACKED
                      ? HorizontalRestaurantListItem(restaurant: restaurants[i])
                      : VerticalRestaurantListItem(restaurant: restaurants[i]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

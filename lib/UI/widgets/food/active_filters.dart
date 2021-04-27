import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/food/active_filter_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';

class ActiveFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (c, restaurantsProvider, _) {
        Map<String, dynamic> filterData = restaurantsProvider.filterData;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: screenHorizontalPadding, left: screenHorizontalPadding, bottom: 10),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              if (filterData['delivery_type'] != null)
                ActiveFilterItem(
                  closeAction:
                      filterData['delivery_type'] == 'all' ? null : () => removeFilterItem(restaurantsProvider, 'delivery_type', value: 'all'),
                  title: Translations.of(context).get("Delivery Type: ${filterData['delivery_type']}"),
                ),
              if (filterData['min_rating'] != null)
                ActiveFilterItem(
                  closeAction: () => removeFilterItem(restaurantsProvider, 'min_rating'),
                  title: '${Translations.of(context).get("Minimum Rating")} ${filterData['min_rating']}',
                ),
              if (restaurantsProvider.minCartValue != null && filterData['minimum_order'] != restaurantsProvider.minCartValue)
                ActiveFilterItem(
                  closeAction: () => removeFilterItem(restaurantsProvider, 'minimum_order', value: restaurantsProvider.minCartValue),
                  title: '${Translations.of(context).get("Minimum Order")} ${filterData['minimum_order']} IQD',
                ),
              if (filterData['categories'].length > 0)
                ...List.generate(filterData['categories'].length, (i) {
                  String categoryTitle = restaurantsProvider.getFoodCategoryTitleFromId(filterData['categories'][i]);
                  return categoryTitle == null
                      ? Container()
                      : ActiveFilterItem(
                          closeAction: () {
                            final _newFilterData = filterData['categories'].where((categoryId) => categoryId != filterData['categories'][i]).toList();
                            removeFilterItem(restaurantsProvider, 'categories', value: _newFilterData);
                          },
                          title: categoryTitle,
                        );
                }),
              ActiveFilterItem(
                closeAction: restaurantsProvider.sortType == RestaurantSortType.SMART ? null : () => removeFilterItem(restaurantsProvider, 'sort'),
                title: Translations.of(context).get("Sort by: ${restaurantSortTypeValues.reverse[restaurantsProvider.sortType]}"),
              ),
            ],
          ),
        );
      },
    );
  }

  void removeFilterItem(RestaurantsProvider restaurantsProvider, String key, {dynamic value}) {
    if (key == 'sort') {
      restaurantsProvider.setSortType(RestaurantSortType.SMART);
    } else {
      restaurantsProvider.setFilterData(key: key, value: value);
    }
    restaurantsProvider.submitFiltersAndSort();
    // showToast(msg: '${restaurantsProvider.filteredRestaurants.length} ${Translations.of(context).get("result(s) match your search')}");
  }
}

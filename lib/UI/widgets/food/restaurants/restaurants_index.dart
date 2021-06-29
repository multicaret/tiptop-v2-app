import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_horizontal_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_vertical_list_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantsIndex extends StatelessWidget {
  final bool hasLoadingItem;
  final List<Branch> restaurants;

  RestaurantsIndex({
    this.hasLoadingItem = false,
    this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantsProvider, AppProvider>(
      builder: (c, restaurantsProvider, appProvider, _) {
        List<Map<String, dynamic>> listTypes = restaurantsProvider.listTypes;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: appProvider.isRTL ? 0 : screenHorizontalPadding,
                right: appProvider.isRTL ? screenHorizontalPadding : 0,
                bottom: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Translations.of(context).get("Restaurants"), style: AppTextStyles.body50),
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
                              color: restaurantsProvider.activeListType == listTypes[i]['type'] ? AppColors.primary : AppColors.primary50,
                              width: 18,
                              height: 16,
                            ),
                          ),
                          onTap: () => restaurantsProvider.setActiveListType(listTypes[i]['type']),
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
              itemCount: restaurants.length + 1,
              itemBuilder: (c, i) => i < restaurants.length
                  ? Material(
                      color: AppColors.white,
                      child: InkWell(
                        onTap: () => pushCupertinoPage(
                          context,
                          RestaurantPage(restaurantId: restaurants[i].id),
                        ),
                        child: restaurantsProvider.activeListType == ListType.HORIZONTALLY_STACKED
                            ? RestaurantHorizontalListItem(restaurant: restaurants[i])
                            : RestaurantVerticalListItem(restaurant: restaurants[i]),
                      ),
                    )
                  : hasLoadingItem
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: AppLoader(width: 150),
                        )
                      : Container(),
            ),
          ],
        );
      },
    );
  }
}

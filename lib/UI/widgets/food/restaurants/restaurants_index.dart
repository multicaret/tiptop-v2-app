import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/horizontal_restaurant_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/vertical_restaurant_list_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantsIndex extends StatefulWidget {
  final List<Branch> restaurants;

  RestaurantsIndex({@required this.restaurants});

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
        Padding(
          padding: const EdgeInsets.only(left: screenHorizontalPadding, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${Translations.of(context).get("Restaurants")} (${widget.restaurants.length})', style: AppTextStyles.body50),
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
          itemCount: widget.restaurants.length,
          itemBuilder: (c, i) => Material(
            color: AppColors.white,
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                RestaurantPage.routeName,
                arguments: widget.restaurants[i].id,
              ),
              child: activeListType == ListType.HORIZONTALLY_STACKED
                  ? HorizontalRestaurantListItem(restaurant: widget.restaurants[i])
                  : VerticalRestaurantListItem(restaurant: widget.restaurants[i]),
            ),
          ),
        ),
      ],
    );
  }
}

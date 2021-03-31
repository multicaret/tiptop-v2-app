import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/UI/circle_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/dicount_badge.dart';
import 'package:tiptop_v2/UI/widgets/UI/labeled_icon.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_list_item_cover.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class VerticalRestaurantListItem extends StatefulWidget {
  final Restaurant restaurant;

  VerticalRestaurantListItem({@required this.restaurant});

  @override
  _VerticalRestaurantListItemState createState() => _VerticalRestaurantListItemState();
}

class _VerticalRestaurantListItemState extends State<VerticalRestaurantListItem> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RestaurantListItemCover(
            restaurant: widget.restaurant,
            isFavorited: isFavorited,
            favoriteAction: () => setState(() => isFavorited = !isFavorited),
          ),
          SizedBox(height: 10),
          Text(widget.restaurant.title),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleIcon(iconImage: 'assets/images/logo-man-only.png'),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            Translations.of(context).get("TipTop delivery"),
                            style: AppTextStyles.subtitle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        LabeledIcon(icon: FontAwesomeIcons.hourglassHalf, text: '15-20'),
                        SizedBox(width: 10),
                        LabeledIcon(icon: FontAwesomeIcons.shoppingBasket, text: '25 IQD'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleIcon(iconText: 'R'),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Text(
                                Translations.of(context).get("Restaurant delivery"),
                                style: AppTextStyles.subtitle,
                              ),
                            ),
                          ],
                        ),
                        if (widget.restaurant.discountValue != null) DiscountBadge(value: widget.restaurant.discountValue),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        LabeledIcon(icon: FontAwesomeIcons.hourglassHalf, text: '15-20'),
                        SizedBox(width: 10),
                        LabeledIcon(icon: FontAwesomeIcons.shoppingBasket, text: '25 IQD'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

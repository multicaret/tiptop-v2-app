import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/UI/circle_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/labeled_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class HorizontalRestaurantListItem extends StatelessWidget {
  final Restaurant restaurant;

  HorizontalRestaurantListItem({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primary50)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 116,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      restaurant.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                    color: Colors.black.withOpacity(0.8),
                  ),
                  height: 29,
                  child: RatingInfo(
                    ratingValue: 3.5,
                    ratingsCount: 250,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(restaurant.title),
                Column(
                  children: [
                    Row(
                      children: [
                        CircleIcon(iconImage: 'assets/images/logo-man-only.png'),
                        const SizedBox(width: 5),
                        Expanded(child: LabeledIcon(icon: FontAwesomeIcons.hourglassHalf, text: '15-20')),
                        const SizedBox(width: 10),
                        Expanded(child: LabeledIcon(icon: FontAwesomeIcons.shoppingBasket, text: '25 IQD')),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleIcon(iconText: 'R'),
                        const SizedBox(width: 5),
                        Expanded(child: LabeledIcon(icon: FontAwesomeIcons.hourglassHalf, text: '15-20')),
                        const SizedBox(width: 10),
                        Expanded(child: LabeledIcon(icon: FontAwesomeIcons.shoppingBasket, text: '25 IQD')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

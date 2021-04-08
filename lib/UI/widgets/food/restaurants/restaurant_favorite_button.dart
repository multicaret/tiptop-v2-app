import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RestaurantFavoriteButton extends StatefulWidget {
  final int restaurantId;

  RestaurantFavoriteButton({@required this.restaurantId});

  @override
  _RestaurantFavoriteButtonState createState() => _RestaurantFavoriteButtonState();
}

class _RestaurantFavoriteButtonState extends State<RestaurantFavoriteButton> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isFavorited = !isFavorited),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(blurRadius: 6, color: AppColors.shadow),
          ],
        ),
        child: AppIcons.iconMdSecondary(isFavorited ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
      ),
    );
  }
}

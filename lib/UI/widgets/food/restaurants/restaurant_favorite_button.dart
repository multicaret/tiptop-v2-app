import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RestaurantFavoriteButton extends StatefulWidget {
  final int restaurantId;

  RestaurantFavoriteButton({
    @required this.restaurantId,
  });

  @override
  _RestaurantFavoriteButtonState createState() => _RestaurantFavoriteButtonState();
}

class _RestaurantFavoriteButtonState extends State<RestaurantFavoriteButton> {
  bool restaurantIsFavorited = false;
  bool _isLoadingInteractRequest = false;

  RestaurantsProvider restaurantsProvider;
  AppProvider appProvider;

  Future<void> interactWithRestaurant() async {
    setState(() {
      _isLoadingInteractRequest = true;
    });
    await restaurantsProvider.interactWithRestaurant(
      appProvider,
      widget.restaurantId,
      restaurantIsFavorited ? Interaction.UN_FAVORITE : Interaction.FAVORITE,
      context,
    );
    setState(() => _isLoadingInteractRequest = false);
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    restaurantIsFavorited = restaurantsProvider.getRestaurantFavoriteStatus(widget.restaurantId);
    return appProvider.isAuth
        ? GestureDetector(
            onTap: _isLoadingInteractRequest ? null : interactWithRestaurant,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  const BoxShadow(blurRadius: 6, color: AppColors.shadow),
                ],
              ),
              child: AppIcons.iconMdSecondary(restaurantIsFavorited ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
            ),
          )
        : Container();
  }
}

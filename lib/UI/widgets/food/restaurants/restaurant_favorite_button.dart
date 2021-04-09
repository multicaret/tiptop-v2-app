import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RestaurantFavoriteButton extends StatefulWidget {
  final int restaurantId;
  final bool isFavorited;

  RestaurantFavoriteButton({
    @required this.restaurantId,
    this.isFavorited = false,
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
    bool _restaurantIsFavorited = restaurantIsFavorited;
    setState(() {
      restaurantIsFavorited = !restaurantIsFavorited;
      _isLoadingInteractRequest = true;
    });
    try {
      await restaurantsProvider.interactWithRestaurant(
        appProvider,
        widget.restaurantId,
        _restaurantIsFavorited ? Interaction.UN_FAVORITE : Interaction.FAVORITE,
      );
      setState(() => _isLoadingInteractRequest = false);
      showToast(msg: _restaurantIsFavorited ? 'Successfully removed restaurant from favorites!' : 'Successfully added restaurant to favorites!');
    } catch (e) {
      setState(() {
        restaurantIsFavorited = _restaurantIsFavorited;
        _isLoadingInteractRequest = false;
      });
      showToast(msg: "An error occurred and we couldn't add this restaurant to your favorites!");
      throw e;
    }
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
      restaurantIsFavorited = widget.isFavorited;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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

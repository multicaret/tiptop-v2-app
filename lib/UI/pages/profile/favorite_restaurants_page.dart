import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_vertical_list_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class FavoriteRestaurantsPage extends StatefulWidget {
  static const routeName = '/favorite-restaurants';

  @override
  _FavoriteRestaurantsPageState createState() => _FavoriteRestaurantsPageState();
}

class _FavoriteRestaurantsPageState extends State<FavoriteRestaurantsPage> {
  bool _isInit = true;
  bool _isLoadingFavoriteRestaurants = false;

  RestaurantsProvider restaurantsProvider;
  AppProvider appProvider;
  List<Branch> favoriteRestaurants = [];

  Future<void> _fetchAndSetFavoriteRestaurants() async {
    setState(() => _isLoadingFavoriteRestaurants = true);
    await restaurantsProvider.fetchAndSetFavoriteRestaurants(appProvider);
    favoriteRestaurants = restaurantsProvider.favoriteRestaurants
        .where((maybeFavoriteRestaurant) => restaurantsProvider.getRestaurantFavoriteStatus(maybeFavoriteRestaurant.id))
        .toList();
    setState(() => _isLoadingFavoriteRestaurants = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      _fetchAndSetFavoriteRestaurants();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    favoriteRestaurants = restaurantsProvider.favoriteRestaurants
        .where((maybeFavoriteRestaurant) => restaurantsProvider.getRestaurantFavoriteStatus(maybeFavoriteRestaurant.id))
        .toList();
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get("Favorite Restaurants")),
      ),
      body: _isLoadingFavoriteRestaurants
          ? const AppLoader()
          : favoriteRestaurants.length == 0
              ? Center(
                  child: Text('No favorite restaurants added yet!'),
                )
              : RefreshIndicator(
                  onRefresh: _fetchAndSetFavoriteRestaurants,
                  child: ListView.builder(
                    itemCount: favoriteRestaurants.length,
                    itemBuilder: (c, i) => Material(
                      color: AppColors.white,
                      child: InkWell(
                        onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                          RestaurantPage.routeName,
                          arguments: {
                            'restaurant_id': favoriteRestaurants[i].id,
                          },
                        ),
                        child: RestaurantVerticalListItem(restaurant: favoriteRestaurants[i]),
                      ),
                    ),
                  ),
                ),
    );
  }
}

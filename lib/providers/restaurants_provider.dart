import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';

class RestaurantsProvider with ChangeNotifier {
  Branch restaurant;
  List<Category> menuCategories;
  List<Branch> favoriteRestaurants = [];

  Map<int, bool> restaurantsFavoriteStatuses = {};

  bool getRestaurantFavoriteStatus(int restaurantId) {
    return restaurantsFavoriteStatuses[restaurantId] == null ? false : restaurantsFavoriteStatuses[restaurantId];
  }

  Future<void> fetchAndSetRestaurant(AppProvider appProvider, int restaurantId) async {
    final endpoint = 'restaurants/$restaurantId';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: appProvider.isAuth);
    restaurant = Branch.fromJson(responseData["data"]);
    menuCategories = restaurant.categories.where((category) => category.products.length > 0).toList();
    notifyListeners();
  }

  Future<void> interactWithRestaurant(AppProvider appProvider, int restaurantId, Interaction interaction) async {
    bool _oldIsFavorite = restaurantsFavoriteStatuses[restaurantId];
    restaurantsFavoriteStatuses[restaurantId] = interaction == Interaction.FAVORITE;
    notifyListeners();

    final endpoint = 'restaurants/$restaurantId/interact';
    final body = {
      "action": getInteractionValue(interaction),
    };
    print(body);
    print('productId $restaurantId');
    print('action: ${getInteractionValue(interaction)}');
    try {
      final responseData = await appProvider.post(
        endpoint: endpoint,
        body: body,
        withToken: true,
      );
      print(responseData);
      if (responseData == 401) {
        print('Unauthenticated!');
        restaurantsFavoriteStatuses[restaurantId] = _oldIsFavorite;
        notifyListeners();
        return 401;
      }
      showToast(
          msg: interaction == Interaction.UN_FAVORITE
              ? 'Successfully removed restaurant from favorites!'
              : 'Successfully added restaurant to favorites!');
      restaurantsFavoriteStatuses[restaurantId] = interaction == Interaction.FAVORITE;
      notifyListeners();
    } catch (e) {
      print('An error occurred!');
      showToast(msg: "An error occurred and we couldn't add this restaurant to your favorites!");
      restaurantsFavoriteStatuses[restaurantId] = _oldIsFavorite;
      notifyListeners();
    }
  }

  Future<dynamic> fetchAndSetFavoriteRestaurants(AppProvider appProvider) async {
    final endpoint = 'profile/restaurants/favorites';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: true);
    if (responseData == 401) {
      print('Unauthenticated!');
      return 401;
    }
    favoriteRestaurants = List<Branch>.from(responseData["data"]["restaurants"].map((x) => Branch.fromJson(x)));
    favoriteRestaurants.forEach((favoriteRestaurant) {
      restaurantsFavoriteStatuses[favoriteRestaurant.id] = true;
    });
    notifyListeners();
  }
}

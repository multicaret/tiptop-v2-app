import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class RestaurantsProvider with ChangeNotifier {
  Branch restaurant;
  List<Category> menuCategories;

  Future<void> fetchAndSetRestaurant(AppProvider appProvider, int restaurantId) async {
    final endpoint = 'restaurants/$restaurantId';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: appProvider.isAuth);
    restaurant = Branch.fromJson(responseData["data"]);
    menuCategories = restaurant.categories.where((category) => category.products.length > 0).toList();
    notifyListeners();
  }
}
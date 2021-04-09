import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
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

  Future<void> interactWithRestaurant(AppProvider appProvider, int restaurantId, Interaction interaction) async {
    final endpoint = 'restaurants/$restaurantId/interact';
    final body = {
      "action": getInteractionValue(interaction),
    };
    print(body);
    print('productId $restaurantId');
    print('action: ${getInteractionValue(interaction)}');
    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );
    print(responseData);
    if (responseData == 401) {
      print('Unauthenticated!');
      return 401;
    }
    notifyListeners();
  }
 }
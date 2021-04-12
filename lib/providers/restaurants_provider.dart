import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/circle_icon.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';

class RestaurantsProvider with ChangeNotifier {
  Branch restaurant;
  List<Category> menuCategories;
  List<Category> foodCategories;
  List<Branch> favoriteRestaurants = [];
  List<Branch> restaurants = [];
  List<Branch> filteredRestaurants = [];
  ListType activeListType = ListType.HORIZONTALLY_STACKED;

  double minCartValue;
  double maxCartValue;
  Map<String, dynamic> filterData = {
    'delivery_type': null,
    'minimum_order': null,
    'min_rating': null,
    'categories': <int>[],
  };
  bool isLoadingSubmitFilterAndSort = false;
  RestaurantSortType sortType = RestaurantSortType.SMART;

  List<Map<String, dynamic>> listTypes = [
    {
      'type': ListType.HORIZONTALLY_STACKED,
      'icon': 'assets/images/list-view-icon.png',
    },
    {
      'type': ListType.VERTICALLY_STACKED,
      'icon': 'assets/images/grid-view-icon.png',
    },
  ];

  List<Map<String, dynamic>> restaurantDeliveryTypes = [
    {
      'id': getRestaurantDeliveryTypeString(RestaurantDeliveryType.TIPTOP),
      'title': 'TipTop Delivery',
      'type': RestaurantDeliveryType.TIPTOP,
      'icon': CircleIcon(iconImage: 'assets/images/logo-man-only.png'),
    },
    {
      'id': getRestaurantDeliveryTypeString(RestaurantDeliveryType.RESTAURANT),
      'title': 'Restaurant Delivery',
      'type': RestaurantDeliveryType.RESTAURANT,
      'icon': CircleIcon(iconText: 'R'),
    },
  ];

  void setRestaurantData(HomeData foodHomeData) {
    restaurants = foodHomeData.restaurants;
    filteredRestaurants = foodHomeData.restaurants;
    foodCategories = foodHomeData.categories;
    foodHomeData.restaurants.forEach((restaurant) {
      restaurantsFavoriteStatuses[restaurant.id] = restaurant.isFavorited;
    });
  }

  void setFilterData({Map<String, dynamic> data, String key, dynamic value}) {
    if (key != null && value != null) {
      filterData[key] = value;
    } else {
      filterData = data;
    }
    print(filterData);
    notifyListeners();
  }

  void setSortValue(RestaurantSortType _sortValue) {
    sortType = _sortValue;
    notifyListeners();
  }

  bool get filtersAreEmpty =>
      filterData['delivery_type'] == null &&
      filterData['min_rating'] == null &&
      filterData['minimum_order'] == minCartValue &&
      filterData['categories'].length == 0;

  void setActiveListType(ListType value) {
    activeListType = value;
    notifyListeners();
  }

  String getFoodCategoryTitleFromId(int id) {
    if (foodCategories != null && foodCategories.length > 0) {
      final targetCategory = foodCategories.firstWhere((category) => category.id == id);
      return targetCategory == null ? null : targetCategory.title;
    } else {
      return null;
    }
  }

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

  Future<void> createFilters() async {
    final endpoint = 'restaurants/filter';
    final responseData = await AppProvider().get(endpoint: endpoint);
    foodCategories = List<Category>.from(responseData["data"]["categories"].map((x) => Category.fromJson(x)));
    minCartValue = responseData["data"]["minCart"] == null ? 0.0 : responseData["data"]["minCart"].toDouble();
    maxCartValue = responseData["data"]["maxCart"] == null ? 0.0 : responseData["data"]["maxCart"].toDouble();
    filterData['minimum_order'] = minCartValue;
    notifyListeners();
  }

  Future<void> submitFiltersAndSort({Map<String, dynamic> sortData}) async {
    isLoadingSubmitFilterAndSort = true;
    notifyListeners();
    final endpoint = 'restaurants';
    Map<String, dynamic> body = filterData;
    body['sort'] = getRestaurantSortTypeString(sortType);
    if (sortType == RestaurantSortType.DISTANCE) {
      if(sortData == null) {
        print('Sort data for distance sorting is empty!!! 😱');
        return;
      }
      body.addAll(sortData);
    }
    print(body);
    final responseData = await AppProvider().post(endpoint: endpoint, body: body);
    filteredRestaurants = List<Branch>.from(responseData["data"].map((x) => Branch.fromJson(x)));
    isLoadingSubmitFilterAndSort = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';

class RestaurantsPage extends StatefulWidget {
  static const routeName = '/restaurants';

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  bool _isInit = true;
  bool _isLoadingFilterRequest = false;

  List<Category> foodCategories = [];
  List<Branch> restaurants = [];

  @override
  void didChangeDependencies() {
    if(_isInit) {
/*      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      foodCategories = data["food_categories"];
      restaurants = data["restaurants"];*/
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          FilterSortButtons(foodCategories: foodCategories),
          Expanded(
            child: SingleChildScrollView(
              child: RestaurantsIndex(restaurants: restaurants),
            ),
          ),
        ],
      ),
    );
  }
}

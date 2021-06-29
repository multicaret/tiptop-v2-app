import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/active_filters.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RestaurantsPage extends StatefulWidget {
  static const routeName = '/restaurants';
  final int selectedCategoryId;

  RestaurantsPage({this.selectedCategoryId});

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isInit = true;
  RestaurantsProvider restaurantsProvider;

  // int _currentPage = 1;
  int _totalRestaurants;
  int _lastPage;
  bool _isLoadingMoreRestaurants = false;
  bool _isLoadingResetFiltersRequest = false;

  Future<void> _fetchAndSetRestaurants({bool toRefresh = false}) async {
    await restaurantsProvider.fetchAndSetRestaurants(page: toRefresh ? 1 : null);
    _totalRestaurants = restaurantsProvider.restaurantsPagination.total;
    _lastPage = restaurantsProvider.restaurantsPagination.totalPages;
    print("_totalRestaurants: $_totalRestaurants");
    print("currentPage: ${restaurantsProvider.restaurantsPagination.currentPage}");
    print("_lastPage: $_lastPage");
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
      int initiallySelectedCategoryId = widget.selectedCategoryId;
      if (restaurantsProvider.filteredRestaurants.length == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fetchAndSetRestaurants();
        });
      }

      if (initiallySelectedCategoryId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          restaurantsProvider.setFilterData(key: 'categories', value: [initiallySelectedCategoryId]);
          _fetchAndSetRestaurants();
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoadingFirstRestaurantsFetch =
        restaurantsProvider.isLoadingFetchRestaurantsRequest && !_isLoadingMoreRestaurants;
    return AppScaffold(
      hasOverlayLoader: _isLoadingFirstRestaurantsFetch,
      appBarActions: [
        if (!restaurantsProvider.filtersAreEmpty)
          IconButton(
            onPressed: () {
              restaurantsProvider.setFilterData(data: {
                'delivery_type': 'all',
                'min_rating': null,
                'minimum_order': restaurantsProvider.minCartValue,
                'categories': <int>[],
              });
              setState(() {
                _isLoadingResetFiltersRequest = true;
              });
              _fetchAndSetRestaurants(toRefresh: true).then((_) {
                setState(() {
                  _isLoadingResetFiltersRequest = false;
                });
              });
            },
            icon: AppIcons.icon(FontAwesomeIcons.eraser),
          )
      ],
      body: Column(
        children: [
          FilterSortButtons(shouldPopOnly: true),
          ActiveFilters(),
          Expanded(
            child: _isLoadingFirstRestaurantsFetch
                ? Container()
                : restaurantsProvider.filteredRestaurants.length == 0
                    ? Center(
                        child: Text(Translations.of(context).get("No Results Match Your Search")),
                      )
                    : NotificationListener(
                        onNotification: (ScrollNotification scrollInfo) {
                          bool _canFetchMoreRestaurants = !_isLoadingMoreRestaurants &&
                              !restaurantsProvider.isLoadingFetchRestaurantsRequest &&
                              scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200 &&
                              (_lastPage == null || restaurantsProvider.currentPage <= _lastPage);

                          if (_canFetchMoreRestaurants) {
                            setState(() {
                              _isLoadingMoreRestaurants = true;
                            });
                            _fetchAndSetRestaurants().then((_) {
                              setState(() {
                                _isLoadingMoreRestaurants = false;
                              });
                            });
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () => _fetchAndSetRestaurants(toRefresh: true),
                          child: SingleChildScrollView(
                            child: RestaurantsIndex(
                              restaurants: restaurantsProvider.filteredRestaurants,
                              hasLoadingItem: _isLoadingMoreRestaurants,
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

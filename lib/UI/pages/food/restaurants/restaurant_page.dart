import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_horizontal_tabs.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_vertical_content.dart';
import 'package:tiptop_v2/UI/widgets/food/products/food_product_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_header_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_search_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/restaurant';

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  AutoScrollController categoriesScrollController;
  AutoScrollController productsScrollController;
  bool _isInit = true;
  bool _isLoadingRestaurantShowRequest = false;

  int restaurantId;
  Branch restaurant;

  TextEditingController searchFieldController = TextEditingController();
  FocusNode searchFieldFocusNode = FocusNode();

  List<Category> menuCategories;
  List<Product> searchProductsResult = [];
  String searchQuery = '';
  Timer debounceTimer;

  AppProvider appProvider;
  RestaurantsProvider restaurantsProvider;

  final selectedCategoryIdNotifier = ValueNotifier<int>(null);

  double expandedHeaderHeight;
  List<Map<String, dynamic>> categoriesHeights;

  final _collapsedNotifier = ValueNotifier<bool>(false);

  void scrollListener() {
    if (productsScrollController.hasClients) {
      if (productsScrollController.offset >= expandedHeaderHeight - restaurantPageCollapsedHeaderHeight) {
        _collapsedNotifier.value = true;
      } else if (productsScrollController.offset < (expandedHeaderHeight - restaurantPageCollapsedHeaderHeight)) {
        _collapsedNotifier.value = false;
      }
    }
  }

  Future<void> _fetchAndSetRestaurant() async {
    setState(() => _isLoadingRestaurantShowRequest = true);
    await restaurantsProvider.fetchAndSetRestaurant(appProvider, restaurantId);
    restaurant = restaurantsProvider.restaurant;
    menuCategories = restaurantsProvider.menuCategories;
    setState(() => _isLoadingRestaurantShowRequest = false);
  }

  @override
  void initState() {
    categoriesScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    productsScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
    productsScrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      restaurantId = ModalRoute.of(context).settings.arguments as int;
      appProvider = Provider.of<AppProvider>(context);
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
      _fetchAndSetRestaurant().then((_) {
        expandedHeaderHeight = getRestaurantPageExpandedHeaderHeight(
          hasDoubleDelivery:
              restaurant == null ? true : restaurant.tiptopDelivery.isDeliveryEnabled && restaurant.restaurantDelivery.isDeliveryEnabled,
        );
        categoriesHeights = List.generate(
            menuCategories.length,
            (i) => {
                  'id': menuCategories[i].id,
                  'height': foodProductListItemHeight * menuCategories[i].products.length,
                });
        selectedCategoryIdNotifier.value = menuCategories[0].id;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    productsScrollController.removeListener(scrollListener);
    productsScrollController.dispose();
    searchFieldController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  void scrollToCategory(int index) {
    categoriesScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  void scrollToProducts(int index) {
    productsScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  void filterProductsSearchResults(String query) {
    List<Category> categories = [];
    categories.addAll(menuCategories);
    if (query.isNotEmpty) {
      List<Product> searchedProducts = [];
      categories.forEach((category) {
        category.products.forEach((product) {
          if (product.title.toLowerCase().contains(query)) {
            searchedProducts.add(product);
          }
        });
      });
      setState(() {
        searchQuery = query;
        searchProductsResult.clear();
        searchProductsResult.addAll(searchedProducts);
      });
      if (searchedProducts.isEmpty) {
        showToast(msg: Translations.of(context).get('No results match your search'));
      }
      return;
    } else {
      setState(() {
        searchProductsResult.clear();
      });
    }
  }

  void _clearSearchResults() {
    searchFieldController.clear();
    searchFieldFocusNode.unfocus();
    setState(() {
      searchProductsResult = [];
      searchQuery = '';
    });
  }

  _onSearchFieldChange(value) {
    const duration = Duration(milliseconds: 400);
    if (debounceTimer != null) {
      setState(() => debounceTimer.cancel());
    }
    setState(
      () => debounceTimer = Timer(duration, () {
        if (this.mounted && value.length != 0) {
          filterProductsSearchResults(value);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      body: _isLoadingRestaurantShowRequest
          ? AppLoader()
          : CustomScrollView(
              controller: productsScrollController,
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: expandedHeaderHeight,
                  collapsedHeight:
                      searchQuery.isNotEmpty ? sliverAppBarSearchBarHeight : sliverAppBarSearchBarHeight + scrollableHorizontalTabBarHeight,
                  backgroundColor: AppColors.bg,
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: ValueListenableBuilder(
                      valueListenable: _collapsedNotifier,
                      builder: (_, _isCollapsed, __) => Transform.translate(
                        offset: Offset(0, _isCollapsed ? -1 : 0),
                        child: Column(
                          children: [
                            searchQuery.isEmpty
                                ? AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: _isCollapsed ? 1 : 0,
                                    child: IgnorePointer(
                                      ignoring: !_isCollapsed,
                                      child: ValueListenableBuilder(
                                        valueListenable: selectedCategoryIdNotifier,
                                        builder: (c, _selectedChildCategoryId, _) => ScrollableHorizontalTabs(
                                          isInverted: true,
                                          children: menuCategories,
                                          itemScrollController: categoriesScrollController,
                                          selectedChildCategoryId: _selectedChildCategoryId,
                                          //Fired when a child category is clicked
                                          action: (i) {
                                            selectedCategoryIdNotifier.value = menuCategories[i].id;
                                            scrollToCategory(i);
                                            scrollToProducts(i);
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
                              decoration: BoxDecoration(
                                border: _isCollapsed
                                    ? const Border(
                                        bottom: BorderSide(color: AppColors.border),
                                      )
                                    : null,
                                color: AppColors.bg,
                              ),
                              child: RestaurantSearchField(
                                onTap: () {
                                  selectedCategoryIdNotifier.value = menuCategories[0].id;
                                  scrollToCategory(0);
                                  scrollToProducts(0);
                                },
                                focusNode: searchFieldFocusNode,
                                controller: searchFieldController,
                                onChanged: (query) => _onSearchFieldChange(query),
                                onClear: () => _clearSearchResults(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                    ],
                    centerTitle: true,
                    titlePadding: const EdgeInsets.all(0),
                    background: RestaurantHeaderInfo(restaurant: restaurant),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    searchProductsResult.isNotEmpty
                        ? List.generate(
                            searchProductsResult.length,
                            (i) => FoodProductListItem(product: searchProductsResult[i]),
                          )
                        : List.generate(
                            menuCategories.length,
                            (i) {
                              return ScrollableVerticalContent(
                                child: menuCategories[i],
                                index: i,
                                count: menuCategories.length,
                                scrollController: productsScrollController,
                                scrollSpyAction: (i) {
                                  selectedCategoryIdNotifier.value = menuCategories[i].id;
                                  scrollToCategory(i);
                                },
                                firstItemHasTitle: true,
                                categoriesHeights: categoriesHeights,
                                singleTabContent: Column(
                                  children: List.generate(
                                    menuCategories[i].products.length,
                                    (j) => FoodProductListItem(product: menuCategories[i].products[j]),
                                  ),
                                ),
                                pageTopOffset: expandedHeaderHeight,
                              );
                            },
                          ),
                  ),
                )
              ],
            ),
    );
  }
}

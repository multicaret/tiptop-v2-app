import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_search_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_horizontal_list_item.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/providers/search_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'food_product_page.dart';

class FoodSearchPage extends StatefulWidget {
  final Function onSearchSubmitted;
  final bool isLoadingSearchTerms;

  FoodSearchPage({
    this.onSearchSubmitted,
    this.isLoadingSearchTerms = false,
  });

  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  bool _isInit = true;
  bool _isLoading = false;
  String searchQuery = '';

  TextEditingController searchFieldController;
  FocusNode searchFieldFocusNode;

  RestaurantsProvider restaurantsProvider;
  SearchProvider searchProvider;

  List<Branch> _searchedRestaurants = [];

  void _clearSearchResults() {
    searchFieldController.clear();
    searchFieldFocusNode.unfocus();
    setState(() {
      _searchedRestaurants = [];
      searchQuery = '';
    });
  }

  @override
  void initState() {
    searchFieldController = TextEditingController();
    searchFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      restaurantsProvider = Provider.of<RestaurantsProvider>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('🗑 🗑 🗑 🗑 🗑 disposing food search page! 🗑 🗑 🗑 🗑 🗑');
    searchFieldController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AppScaffold(
        hasCurve: false,
        appBar: AppBar(
          title: Text(Translations.of(context).get("Search")),
          actions: [
            if (_searchedRestaurants.isNotEmpty)
              IconButton(
                onPressed: _clearSearchResults,
                icon: AppIcons.icon(FontAwesomeIcons.eraser),
              )
          ],
        ),
        body: Column(
          children: [
            AppSearchField(
              controller: searchFieldController,
              focusNode: searchFieldFocusNode,
              onChanged: submitFoodSearch,
              isLoadingSearchResult: _isLoading,
            ),
            _searchedRestaurants.isNotEmpty
                ? SectionTitle(
                    'Search Results',
                    suffix: ' (${_searchedRestaurants.length})',
                  )
                : Column(
                    children: [
                      SectionTitle('Categories'),
                      CategoriesSlider(
                        categories: restaurantsProvider.foodCategories,
                        onCategoryTap: (String categoryTitle) {
                          searchFieldController.text = categoryTitle;
                          submitFoodSearch(categoryTitle);
                        },
                      ),
                      SectionTitle('Most Searched Terms'),
                    ],
                  ),
            _searchedRestaurants.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchedRestaurants.length,
                        itemBuilder: (c, i) {
                          return Container(
                            child: Column(
                              children: [
                                Material(
                                  color: AppColors.white,
                                  child: InkWell(
                                    onTap: () => pushCupertinoPage(
                                      context,
                                      RestaurantPage(restaurantId: _searchedRestaurants[i].id),
                                    ),
                                    child: RestaurantHorizontalListItem(
                                      restaurant: _searchedRestaurants[i],
                                      isMini: true,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _searchedRestaurants[i].searchProducts.length,
                                    itemBuilder: (c, j) {
                                      var product = _searchedRestaurants[i].searchProducts[j];
                                      return Material(
                                        color: AppColors.white,
                                        child: InkWell(
                                          onTap: () => pushCupertinoPage(
                                            context,
                                            FoodProductPage(
                                              productId: product.id,
                                              restaurantId: _searchedRestaurants[i].id,
                                              chainId: _searchedRestaurants[i].chain.id,
                                              restaurantIsOpen: _searchedRestaurants[i].workingHours.isOpen,
                                            ),
                                            rootNavigator: true,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
                                            decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: AppColors.primary50)),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(product.title),
                                                      if (product.excerpt.raw != null && product.excerpt.raw.isNotEmpty)
                                                        Text(
                                                          product.excerpt.raw,
                                                          style: AppTextStyles.subtitle50,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: FormattedPrices(
                                                    price: product.price,
                                                    discountedPrice: product.discountedPrice,
                                                    isEndAligned: true,
                                                  ),
                                                ),
                                                // Text(
                                                //   product.price.formatted,
                                                //   style: AppTextStyles.subtitleSecondary,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          );
                        }),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Consumer<SearchProvider>(
                        builder: (c, searchProvider, _) => searchProvider.isLoadingSearchTerms
                            ? AppLoader()
                            : Column(
                                children: List.generate(
                                  searchProvider.foodSearchTerms.length,
                                  (i) => Material(
                                    color: AppColors.white,
                                    child: InkWell(
                                      onTap: () {
                                        searchFieldController.text = searchProvider.foodSearchTerms[i].term;
                                        submitFoodSearch(searchProvider.foodSearchTerms[i].term);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: AppColors.border)),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                                        child: Row(
                                          children: [
                                            AppIcons.iconSecondary(FontAwesomeIcons.infoCircle),
                                            const SizedBox(width: 10),
                                            Text(searchProvider.foodSearchTerms[i].term),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> submitFoodSearch(String _searchQuery) async {
    if (searchQuery != _searchQuery) {
      setState(() {
        searchQuery = _searchQuery;
        _isLoading = true;
      });
      await restaurantsProvider.fetchSearchedRestaurants(_searchQuery);
      setState(() {
        _searchedRestaurants = restaurantsProvider.searchedRestaurants;
      });
      if (_searchedRestaurants.isEmpty) {
        showToast(msg: Translations.of(context).get("No results match your search"));
      } else {
        var key = 'Result${_searchedRestaurants.length > 1 ? "s" : ""} match your search';
        showToast(msg: '${_searchedRestaurants.length} ${Translations.of(context).get(key)}');
      }
      if (widget.onSearchSubmitted != null) {
        widget.onSearchSubmitted();
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}

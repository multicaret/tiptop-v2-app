import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_list_items.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FilterBottomSheet extends StatefulWidget {
  final bool shouldPopOnly;

  FilterBottomSheet({this.shouldPopOnly = false});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RestaurantsProvider restaurantsProvider;

  double minCartValue;
  double maxCartValue;
  List<Category> foodCategories = [];

  Map<String, dynamic> filterData;

  bool _isInit = true;
  bool isLoadingFilterData = false;

  Future<void> _createFilters() async {
    setState(() => isLoadingFilterData = true);
    await restaurantsProvider.createFilters();
    foodCategories = restaurantsProvider.foodCategories;
    filterData = restaurantsProvider.filterData;
    minCartValue = restaurantsProvider.minCartValue;
    maxCartValue = restaurantsProvider.maxCartValue;
    setState(() => isLoadingFilterData = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
      _createFilters();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    filterData = restaurantsProvider.filterData;
    bool filtersAreEmpty = restaurantsProvider.filtersAreEmpty;
    final deliveryTypesRadioItems = restaurantsProvider.getRestaurantDeliveryTypes(context);

    return AppBottomSheet(
      hasOverlayLoading: restaurantsProvider.isLoadingSubmitFilterAndSort,
      screenHeightFraction: 0.8,
      title: 'Filters',
      clearAction: filtersAreEmpty ? null : _clearFilters,
      applyAction: () => filtersAreEmpty ? {} : _submitFilters(),
      isLoading: isLoadingFilterData,
      children: isLoadingFilterData
          ? []
          : [
              Padding(
                padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, bottom: 5),
                child: Text(Translations.of(context).get('Delivery Type'), style: AppTextStyles.body50),
              ),
              RadioListItems(
                items: deliveryTypesRadioItems,
                hasBorder: false,
                selectedId: filterData['delivery_type'],
                action: (deliveryType) => restaurantsProvider.setFilterData(key: 'delivery_type', value: deliveryType),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 5,
                  top: 10,
                  left: screenHorizontalPadding,
                  right: screenHorizontalPadding,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(Translations.of(context).get('Min. Cart'), style: AppTextStyles.body50),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text('${minCartValue.round()} IQD'),
                        Expanded(
                          child: Slider(
                            min: minCartValue,
                            max: maxCartValue,
                            value: filterData['minimum_order'].round().toDouble(),
                            label: '${filterData['minimum_order'].round().toDouble()} IQD',
                            onChanged: (newValue) => restaurantsProvider.setFilterData(
                              key: 'minimum_order',
                              value: newValue.round().toDouble(),
                            ),
                          ),
                        ),
                        Text(Translations.of(context).get("All")),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: screenHorizontalPadding),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(Translations.of(context).get("Minimum Rating"), style: AppTextStyles.body50),
                    const SizedBox(height: 5),
                    AppRatingBar(
                      initialRating: filterData['min_rating'],
                      starSize: 30,
                      onRatingUpdate: (value) => restaurantsProvider.setFilterData(key: 'min_rating', value: value),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 10, bottom: 5),
                child: Text(Translations.of(context).get('Categories'), style: AppTextStyles.body50),
              ),
              CategoriesSlider(
                categories: foodCategories,
                selectedCategories: filterData['categories'],
                setSelectedCategories: (_selectedCategoryId) {
                  restaurantsProvider.setFilterData(
                    key: 'categories',
                    value: filterData['categories'].contains(_selectedCategoryId)
                        ? filterData['categories'].where((id) => id != _selectedCategoryId).toList()
                        : <int>[...filterData['categories'], _selectedCategoryId],
                  );
                },
              ),
            ],
    );
  }

  void _clearFilters() {
    restaurantsProvider.setFilterData(data: {
      'delivery_type': 'all',
      'min_rating': null,
      'minimum_order': minCartValue,
      'categories': <int>[],
    });
  }

  Future<void> _submitFilters() async {
    try {
      await restaurantsProvider.submitFiltersAndSort();
      showToast(msg: '${restaurantsProvider.filteredRestaurants.length} result(s) match your search');
      if (widget.shouldPopOnly) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context, rootNavigator: true).pushNamed(RestaurantsPage.routeName);
      }
    } catch (e) {
      throw e;
    }
  }
}

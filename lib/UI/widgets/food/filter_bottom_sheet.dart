import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_select_items.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  AppProvider appProvider;
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
      appProvider = Provider.of<AppProvider>(context);
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
      _createFilters();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (c, restaurantsProvider, _) {
        filterData = restaurantsProvider.filterData;
        return AppBottomSheet(
          screenHeightFraction: 0.8,
          title: 'Filters',
          clearAction: _clearFilters,
          applyAction: _submit,
          isLoading: isLoadingFilterData,
          children: isLoadingFilterData
              ? []
              : [
                  Padding(
                    padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, bottom: 5),
                    child: Text(Translations.of(context).get('Delivery Type'), style: AppTextStyles.body50),
                  ),
                  RadioSelectItems(
                    items: restaurantsProvider.restaurantDeliveryTypes,
                    hasBorder: false,
                    selectedId: filterData['delivery_type'],
                    action: (deliveryType) => restaurantsProvider.setFilterData(key: 'delivery_type', value: deliveryType),
                    isRTL: appProvider.isRTL,
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
                                value: filterData['min_cart_value'].round().toDouble(),
                                label: '${filterData['min_cart_value'].round().toDouble()} IQD',
                                onChanged: (newValue) => restaurantsProvider.setFilterData(
                                  key: 'min_cart_value',
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
                        Text(Translations.of(context).get("Rating"), style: AppTextStyles.body50),
                        const SizedBox(height: 5),
                        AppRatingBar(
                          initialRating: filterData['rating_value'],
                          starSize: 30,
                          onRatingUpdate: (value) => restaurantsProvider.setFilterData(key: 'rating_value', value: value),
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
                    isRTL: appProvider.isRTL,
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
      },
    );
  }

  void _submit() {
    print(filterData);
    Navigator.of(context).pop(filterData);
  }

  void _clearFilters() {
    restaurantsProvider.setFilterData(data: {
      'delivery_type_id': null,
      'min_cart_value': minCartValue,
      'rating_value': 0.0,
      'categories': <int>[],
    });
  }
}

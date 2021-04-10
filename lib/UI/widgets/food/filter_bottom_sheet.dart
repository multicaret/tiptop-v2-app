import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/delivery_info.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<Category> foodCategories;

  FilterBottomSheet({@required this.foodCategories});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  AppProvider appProvider;

  double minSliderValue = 10;
  double maxSliderValue = 100;

  Map<String, dynamic> filterData;

  List<Map<String, dynamic>> deliveryTypes = [
    {
      'id': 0,
      'title': 'Restaurant delivery',
    },
    {
      'id': 1,
      'title': 'TipTop delivery',
    },
  ];

  @override
  void initState() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    filterData = {
      'delivery_type_id': null,
      'min_basket_value': minSliderValue,
      'rating_value': 0.0,
      'category_id': null,
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      screenHeightFraction: 0.8,
      title: 'Filters',
      clearAction: _clearFilters,
      applyAction: _submit,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, bottom: 5),
          child: Text(Translations.of(context).get('Delivery Type'), style: AppTextStyles.body50),
        ),
        // ...deliveryTypesRadioItems(),
        Container(
          padding: const EdgeInsets.only(bottom: 5, top: 10, left: screenHorizontalPadding, right: screenHorizontalPadding,),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
              top: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(Translations.of(context).get('Min Basket'), style: AppTextStyles.body50),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text('${minSliderValue.round()} IQD'),
                  Expanded(
                    child: Slider(
                      min: minSliderValue,
                      max: maxSliderValue,
                      value: filterData['min_basket_value'].round().toDouble(),
                      label: '${filterData['min_basket_value'].round().toDouble()} IQD',
                      onChanged: (newValue) => setState(() => filterData['min_basket_value'] = newValue.round().toDouble()),
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
                onRatingUpdate: (value) => setState(() => filterData['rating_value'] = value),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 10, bottom: 5),
          child: Text(Translations.of(context).get('Categories'), style: AppTextStyles.body50),
        ),
        CategoriesSlider(
          categories: widget.foodCategories,
          isRTL: appProvider.isRTL,
          selectedCategoryId: filterData['selected_category_id'],
          setSelectedCategoryId: (_selectedCategoryId) => setState(() => filterData['selected_category_id'] = _selectedCategoryId),
        ),
      ],
    );
  }

  List<Widget> deliveryTypesRadioItems() {
    return List.generate(deliveryTypes.length, (i) {
      return Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () => setState(() => filterData['delivery_type_id'] = deliveryTypes[i]['id']),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: appProvider.isRTL ? screenHorizontalPadding : 12, right: appProvider.isRTL ? 12 : screenHorizontalPadding,),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppColors.primary,
                  value: deliveryTypes[i]["id"],
                  groupValue: filterData['delivery_type_id'],
                  onChanged: (newValue) => setState(() => filterData['delivery_type_id'] = newValue),
                ),
                Expanded(
                  child: DeliveryInfo(isRestaurant: i == 0),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _submit() {
    print(filterData);
    Navigator.of(context).pop(filterData);
  }

  void _clearFilters() {
    setState(() {
      filterData = {
        'delivery_type_id': null,
        'min_basket_value': minSliderValue,
        'rating_value': 0.0,
        'category_id': null,
      };
    });
  }
}

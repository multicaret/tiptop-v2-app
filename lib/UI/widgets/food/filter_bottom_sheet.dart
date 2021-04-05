import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/delivery_info.dart';
import 'package:tiptop_v2/dummy_data.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  AppProvider appProvider;

  final List<Map<String, dynamic>> deliveryTypes = [
    {
      'id': 0,
      'title': 'Restaurant delivery',
    },
    {
      'id': 1,
      'title': 'TipTop delivery',
    },
  ];

  double minSliderValue = 10;
  double maxSliderValue = 100;
  double sliderValue = 10;
  int selectedDeliveryTypeId = 0;

  @override
  void initState() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      screenHeightFraction: 0.8,
      title: 'Filters',
      clearAction: () {},
      applyAction: () {
        Navigator.of(context).pop();
      },
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 17, right: 17, bottom: 5),
          child: Text(Translations.of(context).get('Delivery Type'), style: AppTextStyles.body50),
        ),
        ...deliveryTypesRadioItems(),
        Container(
          padding: const EdgeInsets.only(bottom: 5, top: 10, left: 17, right: 17),
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
              SizedBox(height: 5),
              Row(
                children: [
                  Text('${minSliderValue.round()} IQD'),
                  Expanded(
                    child: Slider(
                      min: minSliderValue,
                      max: maxSliderValue,
                      value: sliderValue,
                      label: '${sliderValue.round()} IQD',
                      onChanged: (newValue) {
                        setState(() {
                          sliderValue = newValue;
                        });
                      },
                    ),
                  ),
                  Text(Translations.of(context).get("All")),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(Translations.of(context).get("Rating"), style: AppTextStyles.body50),
              SizedBox(height: 5),
              AppRatingBar(starSize: 30, onRatingUpdate: (value) => print(value)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 17, right: 17, top: 10, bottom: 5),
          child: Text(Translations.of(context).get('Categories'), style: AppTextStyles.body50),
        ),
        CategoriesSlider(
          categories: dummyCategories,
          isRTL: appProvider.isRTL,
          isCategorySelectable: true,
        ),
      ],
    );
  }

  List<Widget> deliveryTypesRadioItems() {
    return List.generate(deliveryTypes.length, (i) {
      return Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () => setState(() => selectedDeliveryTypeId = deliveryTypes[i]['id']),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: appProvider.isRTL ? 17 : 12, right: appProvider.isRTL ? 12 : 17),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppColors.primary,
                  value: deliveryTypes[i]["id"],
                  groupValue: selectedDeliveryTypeId,
                  onChanged: (newValue) => setState(() => selectedDeliveryTypeId = newValue),
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
}

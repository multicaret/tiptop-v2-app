import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/bottom_sheet_indicator.dart';
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
  final List<Map<String, dynamic>> filterItems = [
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
  int initRadioValue = 0;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
        ),
      ),
      child: Column(
        children: [
          BottomSheetIndicator(),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, left: 17, right: 17),
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Translations.of(context).get('Filters'),
                  style: AppTextStyles.dynamicValues(fontWeight: FontWeight.w600, color: AppColors.secondaryDark, fontSize: 20),
                ),
                Material(
                  color: AppColors.white,
                  child: InkWell(
                    child: SizedBox(
                      width: 50,
                      child: Center(child: Text(Translations.of(context).get('Clear'))),
                    ),
                    onTap: () {
                      // Clear filters
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            //When increasing the horizontal padding, pixels overflow.
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Text(Translations.of(context).get('Delivery Type'), style: AppTextStyles.body50),
                ),
                SizedBox(height: 15),
                DeliveryInfoWithRadio(
                  itemValue: filterItems[0]["id"],
                  initRadioValue: initRadioValue,
                  isRestaurant: false,
                  onChanged: (newValue) {
                    setState(() {
                      initRadioValue = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
                DeliveryInfoWithRadio(
                  itemValue: filterItems[1]["id"],
                  initRadioValue: initRadioValue,
                  isRestaurant: true,
                  onChanged: (newValue) {
                    setState(() {
                      initRadioValue = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          FilterContainer(
            title: Translations.of(context).get('Min Basket'),
            border: Border.all(color: AppColors.border),
            child: Row(
              children: [
                Text(minSliderValue.round().toString()),
                Expanded(
                  child: Slider(
                    min: minSliderValue,
                    max: maxSliderValue,
                    value: sliderValue,
                    label: sliderValue.round().toString(),
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
          ),
          FilterContainer(
            title: Translations.of(context).get("Rating"),
            child: AppRatingBar(starSize: 30),
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17, top: 10),
                  child: Text(Translations.of(context).get('Categories'), style: AppTextStyles.body50),
                ),
                CategoriesSlider(categories: dummyCategories, isRTL: appProvider.isRTL, isCategorySelectable: true),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 17, right: 17, bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: AppColors.secondaryDark),
              child: Text(Translations.of(context).get('Apply'), style: AppTextStyles.body),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Border border;

  FilterContainer({
    this.title,
    this.child,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(border: border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.body50),
          SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}

class DeliveryInfoWithRadio extends StatelessWidget {
  final int itemValue;
  final int initRadioValue;
  final Function onChanged;
  final bool isRestaurant;

  DeliveryInfoWithRadio({
    this.itemValue,
    this.initRadioValue,
    this.onChanged,
    this.isRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 18,
            child: Radio(
              activeColor: AppColors.primary,
              value: itemValue,
              groupValue: initRadioValue,
              onChanged: onChanged,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: DeliveryInfo(isRestaurant: isRestaurant),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/food/sort_bottom_sheet.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';

class FilterSortButtons extends StatelessWidget {
  final Function onSortButtonPressed;
  final Function onFilterButtonPressed;
  final List<Category> foodCategories;

  FilterSortButtons({
    this.onSortButtonPressed,
    this.onFilterButtonPressed,
    @required this.foodCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 30.0),
      child: Row(
        children: [
          Expanded(
            child: AppButtons.primarySm(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: true,
                  builder: (context) => FilterBottomSheet(foodCategories: foodCategories),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.filter),
                  const SizedBox(width: 10),
                  Text(Translations.of(context).get("Filter")),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButtons.primarySm(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SortBottomSheet(),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.sort),
                  const SizedBox(width: 10),
                  Text(Translations.of(context).get("Sort")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

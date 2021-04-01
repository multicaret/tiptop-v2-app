import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/food/sort_bottom_sheet.dart';
import 'package:tiptop_v2/i18n/translations.dart';

class FilterSortButtons extends StatelessWidget {
  final Function onSortButtonPressed;
  final Function onFilterButtonPressed;

  FilterSortButtons({this.onSortButtonPressed, this.onFilterButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 30.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(45)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: true,
                  builder: (context) => FilterBottomSheet(),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.filter),
                  SizedBox(width: 10),
                  Text(Translations.of(context).get("Filter")),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(45)),
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
                  SizedBox(width: 10),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_select_items.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  List<Map<String, dynamic>> sortItems = [
    {
      'id': 0,
      'title': 'Smart Sorting',
      'icon': FontAwesomeIcons.listUl,
    },
    {
      'id': 1,
      'title': 'Restaurant Rating',
      'icon': FontAwesomeIcons.star,
    },
    {
      'id': 2,
      'title': 'Delivery Time',
      'icon': FontAwesomeIcons.stopwatch,
    },
  ];

  int _initRadioValue = 0;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return AppBottomSheet(
      screenHeightFraction: 0.45,
      applyAction: () {},
      title: 'Sort',
      children: [
        Column(
          children: [
            RadioSelectItems(
              items: sortItems,
              selectedId: _initRadioValue,
              action: (value) {
                setState(() {
                  _initRadioValue = value;
                });
              },
              hasBorder: false,
              isRTL: appProvider.isRTL,
            ),
          ],
        ),
      ],
    );
  }
}

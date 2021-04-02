import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_select_items.dart';
import 'package:tiptop_v2/UI/widgets/bottom_sheet_indicator.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              BottomSheetIndicator(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Text(Translations.of(context).get('Sort')),
              ),
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
          Padding(
            padding: EdgeInsets.only(left: 17, right: 17, bottom: 40),
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

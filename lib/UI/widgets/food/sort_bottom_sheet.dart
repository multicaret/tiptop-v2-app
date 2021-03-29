import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  List<Map<String, dynamic>> sortItems = [
    {
      'title': 'Smart Sorting',
      'icon': FontAwesomeIcons.listUl,
      'value': 0,
    },
    {
      'title': 'Restaurant Rating',
      'icon': FontAwesomeIcons.star,
      'value': 1,
    },
    {
      'title': 'Delivery Time',
      'icon': FontAwesomeIcons.stopwatch,
      'value': 2,
    },
  ];

  int _initRadioValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      padding: EdgeInsets.only(left: 17, right: 17, top: 10),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 56,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          Text(Translations.of(context).get('Sort')),
          Divider(thickness: 1),
          Container(
            height: 180,
            child: ListView.builder(
                itemCount: sortItems.length,
                itemBuilder: (context, i) {
                  return RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primary,
                    value: sortItems[i]['value'],
                    groupValue: _initRadioValue,
                    title: Row(
                      children: [
                        Icon(sortItems[i]['icon'], color: AppColors.primary50, size: 20),
                        SizedBox(width: 10),
                        Text(Translations.of(context).get(sortItems[i]['title'])),
                      ],
                    ),
                    onChanged: (value) {
                      setState(() {
                        _initRadioValue = value;
                      });
                    },
                  );
                }),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: AppColors.secondaryDark),
            child: Text(Translations.of(context).get('Apply'), style: AppTextStyles.body),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

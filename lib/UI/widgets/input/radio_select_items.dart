import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class RadioSelectItems extends StatelessWidget {
  final List<dynamic> items;
  final int selectedId;
  final Function action;
  final bool isRTL;

  RadioSelectItems({
    @required this.items,
    @required this.selectedId,
    @required this.action,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (i) {
        return InkWell(
          onTap: () => action(items[i].id),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: isRTL ? 17 : 7,
              right: isRTL ? 7 : 17,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
              color: AppColors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio(
                      value: items[i].id,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      groupValue: selectedId,
                      activeColor: AppColors.secondaryDark,
                      onChanged: (value) => action(value),
                    ),
                    SizedBox(width: 10),
                    Text(items[i].title),
                  ],
                ),
                CachedNetworkImage(
                  imageUrl: items[i].logo,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

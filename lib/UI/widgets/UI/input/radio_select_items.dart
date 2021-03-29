import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class RadioSelectItems extends StatelessWidget {
  final List<dynamic> items;
  final int selectedId;
  final Function action;
  final bool isRTL;
  final bool isAssetLogo;
  final bool hasLogo;

  RadioSelectItems({
    @required this.items,
    @required this.selectedId,
    @required this.action,
    @required this.isRTL,
    this.isAssetLogo = false,
    this.hasLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (i) {
        return Material(
          color: AppColors.white,
          child: InkWell(
            onTap: () => action(items[i]['id']),
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
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: items[i]["id"],
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: selectedId,
                        activeColor: AppColors.secondaryDark,
                        onChanged: (itemId) => action(itemId),
                      ),
                      SizedBox(width: 10),
                      Text(items[i]["title"]),
                    ],
                  ),
                  if(hasLogo)
                  isAssetLogo
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(blurRadius: 6, color: AppColors.shadowDark)],
                          ),
                          child: Image(
                            alignment: Alignment.centerRight,
                            image: AssetImage(items[i]["logo"]),
                            width: 30,
                            height: 30,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: items[i]["logo"],
                          width: 30,
                          fit: BoxFit.cover,
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

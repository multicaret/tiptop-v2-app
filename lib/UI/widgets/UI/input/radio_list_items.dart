import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import '../app_cahched_network_image.dart';

class RadioListItems extends StatelessWidget {
  final List<dynamic> items;
  final dynamic selectedId;
  final Function action;
  final bool isAssetLogo;
  final bool hasBorder;

  RadioListItems({
    @required this.items,
    @required this.selectedId,
    @required this.action,
    this.isAssetLogo = false,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (c, appProvider, _) => Column(
        children: List.generate(items.length, (i) {
          return Material(
            color: AppColors.white,
            child: InkWell(
              onTap: action == null ? null : () => action(items[i]['id']),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: hasBorder ? 10 : 5,
                  bottom: hasBorder ? 10 : 5,
                  left: appProvider.isRTL ? screenHorizontalPadding : 7,
                  right: appProvider.isRTL ? 7 : screenHorizontalPadding,
                ),
                decoration: BoxDecoration(
                  border: hasBorder ? Border(bottom: BorderSide(color: AppColors.border)) : null,
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
                          activeColor: AppColors.secondary,
                          onChanged: action == null ? null : (itemId) => action(itemId),
                        ),
                        if (items[i]["icon"] != null)
                          items[i]["icon"] is Widget
                              ? items[i]["icon"]
                              : Padding(
                                  padding: EdgeInsets.only(left: appProvider.isRTL ? 5 : 15, right: appProvider.isRTL ? 15 : 5),
                                  child: AppIcons.icon50(items[i]["icon"]),
                                ),
                        const SizedBox(width: 10),
                        items[i]["title"] is Widget ? items[i]["title"] : Text(items[i]["title"]),
                      ],
                    ),
                    if (items[i]["logo"] != null)
                      isAssetLogo
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [const BoxShadow(blurRadius: 6, color: AppColors.shadowDark)],
                              ),
                              child: Image(
                                alignment: Alignment.centerRight,
                                image: AssetImage(items[i]["logo"]),
                                width: 30,
                                height: 30,
                              ),
                            )
                          : AppCachedNetworkImage(
                              imageUrl: items[i]["logo"],
                              width: 30,
                            ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

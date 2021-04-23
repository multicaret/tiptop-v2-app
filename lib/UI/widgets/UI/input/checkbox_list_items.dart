import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class CheckboxListItems extends StatelessWidget {
  final List<dynamic> items;
  final List<dynamic> selectedIds;
  final Function action;
  final bool isAssetLogo;
  final bool hasBorder;

  CheckboxListItems({
    @required this.items,
    @required this.selectedIds,
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
              onTap: () => action(items[i]["id"]),
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
                        Checkbox(
                          value: selectedIds.contains(items[i]["id"]),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.secondary,
                          onChanged: (_) => action(items[i]["id"]),
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
                          : CachedNetworkImage(
                              imageUrl: items[i]["logo"],
                              width: 30,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => SpinKitDoubleBounce(
                                color: AppColors.secondary,
                                size: 20,
                              ),
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

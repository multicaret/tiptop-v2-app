import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RadioSelectItems extends StatelessWidget {
  final List<dynamic> items;
  final int selectedId;
  final Function action;
  final bool isRTL;
  final bool isAssetLogo;
  final bool hasBorder;

  RadioSelectItems({
    @required this.items,
    @required this.selectedId,
    @required this.action,
    @required this.isRTL,
    this.isAssetLogo = false,
    this.hasBorder = true,
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
                top: hasBorder ? 10 : 5,
                bottom: hasBorder ? 10 : 5,
                left: isRTL ? 17 : 7,
                right: isRTL ? 7 : 17,
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
                        onChanged: (itemId) => action(itemId),
                      ),
                      if (items[i]["icon"] != null)
                        Padding(
                          padding: EdgeInsets.only(left: isRTL ? 5 : 15, right: isRTL ? 15 : 5),
                          child: AppIcons.icon50(items[i]["icon"]),
                        ),
                      const SizedBox(width: 10),
                      Text(items[i]["title"]),
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
                            placeholder: (_, __) => SpinKitDoubleBounce(color: AppColors.secondary, size: 20,),
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

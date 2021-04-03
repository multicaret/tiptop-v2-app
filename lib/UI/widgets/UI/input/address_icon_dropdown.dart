import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class AddressIconDropDown extends StatelessWidget {
  final List<Map<String, dynamic>> iconItems;
  final int currentIcon;
  final Function onChanged;

  AddressIconDropDown({
    @required this.iconItems,
    @required this.currentIcon,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 72,
      margin: EdgeInsets.only(right: 10, bottom: 20),
      padding: EdgeInsets.only(left: 17, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1.5),
        color: AppColors.bg,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: AppColors.bg),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: currentIcon,
            icon: AppIcons.icon(FontAwesomeIcons.angleDown),
            isExpanded: true,
            itemHeight: 72,
            onChanged: onChanged,
            items: <Map<String, dynamic>>[...iconItems].map<DropdownMenuItem<int>>((Map<String, dynamic> value) {
              return DropdownMenuItem<int>(
                value: value['id'],
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CachedNetworkImage(
                    imageUrl: value['icon_url'],
                    width: 40,
                    alignment: Alignment.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

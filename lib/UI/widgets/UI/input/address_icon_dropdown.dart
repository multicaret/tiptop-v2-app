import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import '../app_cahched_network_image.dart';

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
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Container(
      width: 100,
      height: 72,
      margin: EdgeInsets.only(right: appProvider.isRTL ? 0 : 10, left: appProvider.isRTL ? 10 : 0, bottom: 20),
      padding: const EdgeInsets.only(left: screenHorizontalPadding, right: 10),
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AppCachedNetworkImage(
                    imageUrl: value['icon_url'],
                    width: 40,
                    alignment: Alignment.center,
                    loaderWidget: SpinKitDoubleBounce(color: AppColors.secondary),
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

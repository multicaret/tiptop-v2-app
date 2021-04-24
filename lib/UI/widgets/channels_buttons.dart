import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class ChannelsButtons extends StatelessWidget {
  final Function onPressed;
  final AppChannel selectedChannel;
  final bool isRTL;

  ChannelsButtons({
    this.onPressed,
    this.selectedChannel,
    @required this.isRTL,
  });

  final List<Map<String, dynamic>> channels = [
    {
      'id': AppChannel.FOOD,
      'title': 'Food',
      'image': 'assets/images/tiptop-logo-title-yellow.png',
    },
    {
      'id': AppChannel.MARKET,
      'title': 'Market',
      'image': 'assets/images/tiptop-logo-title-yellow.png',
    },
    /*{
      'id': 'carrefour',
      'image': 'assets/images/carrefour-logo.png',
    },*/
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: screenHorizontalPadding, left: screenHorizontalPadding, top: 10),
      child: Row(
        children: List.generate(channels.length, (i) {
          return Expanded(
            child: Padding(
                padding: i < channels.length - 1 ? EdgeInsets.only(right: isRTL ? 0 : 16, left: isRTL ? 16 : 0) : EdgeInsets.all(0),
                child: AppButtons.dynamic(
                  bgColor: selectedChannel == channels[i]['id'] ? AppColors.primary : AppColors.white,
                  textColor: selectedChannel == channels[i]['id'] ? AppColors.white : AppColors.primary,
                  height: buttonHeightSm,
                  onPressed: () => onPressed(channels[i]['id']),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/tiptop-logo-title-yellow.png'),
                        width: 60,
                      ),
                      if (channels[i]['title'] != null) const SizedBox(width: 10),
                      if (channels[i]['title'] != null) Text(Translations.of(context).get(channels[i]['title'])),
                    ],
                  ),
                )),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class ChannelsButtons extends StatelessWidget {
  final Function changeView;
  final String currentView;

  ChannelsButtons({this.changeView, this.currentView});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 17, left: 17, top: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: currentView == 'food' ? AppColors.primary : AppColors.white,
                onPrimary: currentView == 'food' ? AppColors.white :AppColors.primary,
                minimumSize: Size.fromHeight(45),
              ),
              onPressed: () {
                changeView('food');
              },
              child: Row(
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/tiptop-logo-title-yellow.png'),
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(Translations.of(context).get('Food')),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: currentView == 'market' ? AppColors.primary : AppColors.white,
                onPrimary: currentView == 'market' ? AppColors.white :AppColors.primary,
                minimumSize: Size.fromHeight(45),
              ),
              onPressed: () {
                changeView('market');
              },
              child: Row(
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/tiptop-logo-title-yellow.png'),
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(Translations.of(context).get('Market')),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.white,
                onPrimary: AppColors.primary,
                minimumSize: Size.fromHeight(45),
              ),
              onPressed: () {},
              child: Image(
                image: AssetImage('assets/images/carrefour-logo.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

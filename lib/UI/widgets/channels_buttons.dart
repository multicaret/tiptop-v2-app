import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class ChannelsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.white,
                onPrimary: AppColors.primary,
                minimumSize: Size.fromHeight(45),
              ),
              onPressed: () {},
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
                minimumSize: Size.fromHeight(45),
              ),
              onPressed: () {},
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AddressSelectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: AppColors.primary),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: InkWell(
              onTap: () {
                //Todo: Open Addresses modal/bottom sheet
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: appProvider.dir == 'ltr' ? 17 : 0,
                  right: appProvider.dir == 'ltr' ? 0 : 17,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: appProvider.dir == 'ltr' ? 10 : 0,
                        left: appProvider.dir == 'ltr' ? 0 : 10,
                      ),
                      margin: EdgeInsets.only(
                        right: appProvider.dir == 'ltr' ? 10 : 0,
                        left: appProvider.dir == 'ltr' ? 0 : 10,
                      ),
                      child: Image(
                        image: AssetImage('assets/images/address-home-icon.png'),
                        width: 37,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1,
                            color: AppColors.border,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: AppTextStyles.subtitleBold,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Home',
                                  style: AppTextStyles.subtitle,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Sultan Selim Mah. Tuna Cad. Yasam Evleri Residence',
                                    style: AppTextStyles.subtitle50,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: AppIcon.icon(FontAwesomeIcons.angleRight),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(
                right: appProvider.dir == 'ltr' ? 17 : 0,
                left: appProvider.dir == 'ltr' ? 0 : 17,
                top: 10,
                bottom: 10,
              ),
              color: AppColors.primary,
              child: Column(
                children: [
                  Text(
                    'ETA',
                    style: AppTextStyles.subtitleWhite,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('11', style: AppTextStyles.h2White),
                      SizedBox(width: 3),
                      Text(
                        'min',
                        style: AppTextStyles.subtitleWhiteBold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

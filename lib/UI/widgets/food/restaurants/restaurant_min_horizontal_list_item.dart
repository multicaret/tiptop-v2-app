import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RestaurantMinHorizontalListItem extends StatelessWidget {
  final Branch restaurant;

  RestaurantMinHorizontalListItem({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            RestaurantPage.routeName,
            arguments: restaurant.id,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: restaurant.chain.media.logo,
                    placeholder: (_, __) => SpinKitDoubleBounce(
                      color: AppColors.secondary,
                      size: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(restaurant.title),
              ),
              Consumer<AppProvider>(
                builder: (c, appProvider, _) => AppIcons.icon(appProvider.isRTL ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

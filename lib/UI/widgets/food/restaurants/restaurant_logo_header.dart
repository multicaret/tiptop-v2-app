import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class RestaurantLogoHeader extends StatelessWidget {
  final Branch restaurant;

  RestaurantLogoHeader({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: (restaurantLogoSize / 2) + 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                  ),
                ),
              ),
              Container(
                width: restaurantLogoSize,
                height: restaurantLogoSize,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: (screenSize.width / 2) - (restaurantLogoSize / 2),
                  right: (screenSize.width / 2) - (restaurantLogoSize / 2),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                ),
                child: CachedNetworkImage(
                  placeholder: (_, __) => SpinKitDoubleBounce(color: AppColors.secondary),
                  imageUrl: restaurant.chain.media.logo,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: AppColors.white,
          width: double.infinity,
          child: Text(
            restaurant.title,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/circle_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/labeled_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantHorizontalListItem extends StatelessWidget {
  final Branch restaurant;
  final bool isMini;

  RestaurantHorizontalListItem({@required this.restaurant, this.isMini = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isMini ? listItemHeightSm : listItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: listItemVerticalPaddingSm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primary50)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: isMini ? listItemThumbnailSizeSm : listItemThumbnailSize,
                height: isMini ? listItemThumbnailSizeSm : listItemThumbnailSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    placeholder: (_, __) => SpinKitFadingCircle(color: AppColors.secondary, size: 30),
                    imageUrl: restaurant.chain.media.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (restaurant.rating.averageRaw > 0 && restaurant.rating.countRaw > 0)
                restaurant.rating.countRaw < 10
                    ? Consumer<AppProvider>(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            Translations.of(context).get("New"),
                            style: AppTextStyles.subtitleXsWhite,
                          ),
                        ),
                        builder: (c, appProvider, child) => Positioned(
                          bottom: 5,
                          left: appProvider.isRTL ? null : 5,
                          right: appProvider.isRTL ? 5 : null,
                          child: child,
                        ),
                      )
                    : Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                            color: Colors.black.withOpacity(0.8),
                          ),
                          height: 29,
                          child: RatingInfo(
                            ratingValue: restaurant.rating.averageRaw,
                            ratingsCount: restaurant.rating.countRaw,
                          ),
                        ),
                      ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurant.title),
                Column(
                  children: [
                    if (restaurant.tiptopDelivery.isDeliveryEnabled)
                      Row(
                        children: [
                          CircleIcon(iconImage: 'assets/images/logo-man-only.png'),
                          const SizedBox(width: 5),
                          Expanded(
                            child: LabeledIcon(
                              icon: LineAwesomeIcons.hourglass,
                              text: '${restaurant.tiptopDelivery.minDeliveryMinutes}-${restaurant.tiptopDelivery.maxDeliveryMinutes}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LabeledIcon(
                              icon: LineAwesomeIcons.shopping_basket,
                              text: restaurant.tiptopDelivery.minimumOrder.formatted,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),
                    if (restaurant.restaurantDelivery.isDeliveryEnabled)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleIcon(iconText: 'R'),
                          const SizedBox(width: 5),
                          Expanded(
                            child: LabeledIcon(
                              icon: LineAwesomeIcons.hourglass,
                              text: '${restaurant.restaurantDelivery.minDeliveryMinutes}-${restaurant.restaurantDelivery.maxDeliveryMinutes}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LabeledIcon(
                              icon: LineAwesomeIcons.shopping_basket,
                              text: restaurant.restaurantDelivery.minimumOrder.formatted,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

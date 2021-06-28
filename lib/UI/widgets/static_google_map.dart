import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class StaticGoogleMap extends StatelessWidget {
  final double width;
  final double height;
  final double userLatitude;
  final double userLongitude;
  final double branchLatitude;
  final double branchLongitude;
  final double centerLatitude;
  final double centerLongitude;

  StaticGoogleMap({
    this.width,
    this.height = homeSliderHeight,
    @required this.userLatitude,
    @required this.userLongitude,
    @required this.branchLatitude,
    @required this.branchLongitude,
    @required this.centerLatitude,
    @required this.centerLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return StaticMap(
      height: height,
      googleApiKey: AppProvider.GOOGLE_API_KEY,
      zoom: 1,
      center: Location(centerLatitude, centerLongitude),
      styles: <MapStyle>[
        MapStyle(
          feature: StyleFeature.road,
          rules: <StyleRule>[
            StyleRule.color(AppColors.white),
            StyleRule.visibility(VisibilityRule.simplified),
          ],
        ),
        MapStyle(
          feature: StyleFeature.poi,
          element: StyleElement.labels,
          rules: <StyleRule>[
            StyleRule.visibility(VisibilityRule.off),
          ],
        ),
      ],
      markers: <Marker>[
        Marker.custom(
          icon: "https://stagingnew.trytiptop.app/images/address-home-marker-icon-sm.png",
          locations: [
            Location(userLatitude, userLongitude),
          ],
        ),
        Marker.custom(
          icon: "https://stagingnew.trytiptop.app/images/tiptop-marker-icon-sm.png",
          locations: [
            Location(branchLatitude, branchLongitude),
          ],
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class MapSlide extends StatefulWidget {
  final Address selectedAddress;
  final BranchDelivery delivery;

  MapSlide({
    @required this.selectedAddress,
    @required this.delivery,
  });

  @override
  _MapSlideState createState() => _MapSlideState();
}

class _MapSlideState extends State<MapSlide> with AutomaticKeepAliveClientMixin<MapSlide> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isInit = true;
  AppProvider appProvider;
  double centerLat;
  double centerLong;
  LatLng centerLatLng;

  double userLat;
  double userLong;
  LatLng userLatLng;
  LatLng branchLatLng;

  static String homeMapMarkerIcon = "https://stagingnew.trytiptop.app/images/address-home-marker-icon-sm.png";
  static String branchMapMarkerIcon = "https://stagingnew.trytiptop.app/images/tiptop-marker-icon-sm.png";

  String getGoogleStaticMapLink(BuildContext context) {
    //Example link with all markers visible:
    //https://maps.googleapis.com/maps/api/staticmap?size=512x512&maptype=roadmap\&markers=size:mid%7Ccolor:red%7CSan+Francisco,CA%7COakland,CA%7CSan+Jose,CA&key=YOUR_API_KEY
    String fullUrl = "https://maps.googleapis.com/maps/api/staticmap";

    Size screenSize = MediaQuery.of(context).size;
    double mapWidth = 640; //maximum allowed map width
    double mapHeight = ((mapWidth * homeSliderHeightFraction * screenSize.height) / screenSize.width);
    String size = "size=${mapWidth.ceil()}x${mapHeight.ceil()}&scale=2";
    fullUrl += "?$size";

    String userMarker = "markers=icon:$homeMapMarkerIcon|${userLatLng.latitude},${userLatLng.longitude}";
    fullUrl += "&$userMarker";

    String branchMarker = "markers=icon:$branchMapMarkerIcon|${branchLatLng.latitude},${branchLatLng.longitude}";
    fullUrl += "&$branchMarker";

    fullUrl += "&key=${AppProvider.GOOGLE_API_KEY}";
    return fullUrl;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      branchLatLng = LatLng(MarketProvider.marketBranchLat, MarketProvider.marketBranchLong);

      if (widget.selectedAddress == null) {
        userLat = AppProvider.latitude;
        userLong = AppProvider.longitude;
      } else {
        userLat = widget.selectedAddress.latitude;
        userLong = widget.selectedAddress.longitude;
      }

      userLatLng = LatLng(userLat, userLong);

      centerLat = (branchLatLng.latitude + userLatLng.latitude) / 2;
      centerLong = (branchLatLng.longitude + userLatLng.longitude) / 2;
      centerLatLng = LatLng(centerLat, centerLong);

      print('centerLatLng: $centerLatLng');
      print('userLatLng: $userLatLng');
      print('branchLatLng: $branchLatLng');
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return IgnorePointer(
      ignoring: true,
      child: Container(
        height: homeSliderHeight,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: getGoogleStaticMapLink(context),
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 8,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [const BoxShadow(blurRadius: 10, color: AppColors.shadow)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Text('Minimum ', style: AppTextStyles.subtitleXs, textAlign: TextAlign.end),
                          Expanded(
                            child: Html(
                              data: """${widget.delivery.minimumOrder.formatted}""",
                              style: {"body": AppTextStyles.htmlXsBold},
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(thickness: 1.5),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery ', style: AppTextStyles.subtitleXs, textAlign: TextAlign.end),
                          widget.delivery.fixedDeliveryFee.raw == 0
                              ? Text(
                                  Translations.of(context).get("Free"),
                                  style: AppTextStyles.subtitleXsBold,
                                )
                              : Expanded(
                                  child: Html(
                                    data: """${widget.delivery.fixedDeliveryFee.formatted}""",
                                    style: {"body": AppTextStyles.htmlXsBold},
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

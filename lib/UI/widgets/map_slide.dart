import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/static_google_map.dart';
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

  LatLng initCameraPosition;
  double defaultZoom = 1;

  double userLat;
  double userLong;
  LatLng userLatLng;
  LatLng branchLatLng;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      centerLat = (MarketProvider.marketBranchLat + AppProvider.latitude) / 2;
      centerLong = (MarketProvider.marketBranchLong + AppProvider.longitude) / 2;
      centerLatLng = LatLng(centerLat, centerLong);
      branchLatLng = LatLng(MarketProvider.marketBranchLat, MarketProvider.marketBranchLong);
      print('branchLatLng');
      print(branchLatLng);

      initCameraPosition = LatLng(centerLat, centerLong);
      if (widget.selectedAddress == null) {
        userLat = AppProvider.latitude;
        userLong = AppProvider.longitude;
      } else {
        userLat = widget.selectedAddress.latitude;
        userLong = widget.selectedAddress.longitude;
      }
      userLatLng = LatLng(userLat, userLong);
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
            StaticGoogleMap(
              centerLatLng: centerLatLng,
              userLatLng: userLatLng,
              branchLatLng: branchLatLng,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
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

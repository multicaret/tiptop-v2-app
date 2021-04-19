import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
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
  bool _isInit = true;
  AppProvider appProvider;
  double centerLat;
  double centerLong;
  LatLng initCameraPosition;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  double defaultZoom = 4.0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      centerLat = (HomeProvider.marketBranchLat + AppProvider.latitude) / 2;
      centerLong = (HomeProvider.marketBranchLong + AppProvider.longitude) / 2;
      initCameraPosition = LatLng(centerLat, centerLong);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<Marker> allMarkers = [];
  Marker branchMarker;
  Marker userMarker;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return IgnorePointer(
      ignoring: true,
      child: Container(
        height: homeSliderHeight,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: initCameraPosition, zoom: defaultZoom),
              mapType: MapType.normal,
              markers: Set.from(allMarkers),
              compassEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              myLocationButtonEnabled: false,
              indoorViewEnabled: false,
              onMapCreated: _onMapCreated,
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
                                    Translations.of(context).get('Free'),
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

  bool addressHasLatLng(Address _address) {
    return _address != null && _address.latitude != null && _address.latitude != 0 && _address.latitude != null && _address.longitude != 0;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    print('Carousel map recreated!!');
    _mapController = controller;
    _controller.complete(controller);

    LatLng branchLatLng = LatLng(HomeProvider.marketBranchLat, HomeProvider.marketBranchLong);
    Uint8List branchMarkerIconBytes = await getBytesFromAsset(
      'assets/images/tiptop-marker-icon.png',
      targetWidth: 150,
    );

    LatLng userLatLng = addressHasLatLng(widget.selectedAddress)
        ? LatLng(widget.selectedAddress.latitude, widget.selectedAddress.longitude)
        : LatLng(AppProvider.latitude, AppProvider.longitude);

    Uint8List userMarkerIconBytes = widget.selectedAddress != null && widget.selectedAddress.kind.markerIcon != null
        ? await getAndCacheMarkerIcon(widget.selectedAddress.kind.markerIcon)
        : await getBytesFromAsset('assets/images/address-home-marker-icon.png', targetWidth: 150);

    setState(() {
      userMarker = Marker(
        markerId: MarkerId('user-marker'),
        position: userLatLng,
        icon: BitmapDescriptor.fromBytes(userMarkerIconBytes),
      );
      branchMarker = Marker(
        markerId: MarkerId('main-marker'),
        position: branchLatLng,
        icon: BitmapDescriptor.fromBytes(branchMarkerIconBytes),
      );
      allMarkers.add(userMarker);
      allMarkers.add(branchMarker);
    });

    LatLngBounds bound;
    if (userLatLng.latitude > branchLatLng.latitude && userLatLng.longitude > branchLatLng.longitude) {
      bound = LatLngBounds(southwest: branchLatLng, northeast: userLatLng);
    } else if (userLatLng.longitude > branchLatLng.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(userLatLng.latitude, branchLatLng.longitude), northeast: LatLng(branchLatLng.latitude, userLatLng.longitude));
    } else if (userLatLng.latitude > branchLatLng.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(branchLatLng.latitude, userLatLng.longitude), northeast: LatLng(userLatLng.latitude, branchLatLng.longitude));
    } else {
      bound = LatLngBounds(southwest: userLatLng, northeast: branchLatLng);
    }

    CameraUpdate _cameraUpdate = CameraUpdate.newLatLngBounds(bound, 50);
    this._mapController.animateCamera(_cameraUpdate).then((void v) {
      animate(_cameraUpdate, this._mapController);
    });
  }

  void animate(CameraUpdate cameraUpdate, GoogleMapController controller) async {
    controller.animateCamera(cameraUpdate);
    _mapController.animateCamera(cameraUpdate);
    LatLngBounds firstLatLng = await controller.getVisibleRegion();
    LatLngBounds secondLatLng = await controller.getVisibleRegion();
    if (firstLatLng.southwest.latitude == -90 || secondLatLng.southwest.latitude == -90) animate(cameraUpdate, controller);
  }

  @override
  bool get wantKeepAlive => true;
}

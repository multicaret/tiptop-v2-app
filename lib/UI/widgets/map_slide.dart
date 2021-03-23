import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/home_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class MapSlide extends StatefulWidget {
  @override
  _MapSlideState createState() => _MapSlideState();
}

class _MapSlideState extends State<MapSlide> {
  bool _isInit = true;
  HomeProvider homeProvider;
  AppProvider appProvider;
  double centerLat;
  double centerLong;
  LatLng initCameraPosition;

  Completer<GoogleMapController> _controller = Completer();

  double defaultZoom = 4.0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      homeProvider = Provider.of<HomeProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      centerLat = (HomeProvider.branchLat + AppProvider.latitude) / 2;
      centerLong = (HomeProvider.branchLong + AppProvider.longitude) / 2;
      initCameraPosition = LatLng(centerLat, centerLong);
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Marker branchMarker = Marker(
    markerId: MarkerId('main-marker'),
    position: LatLng(HomeProvider.branchLat, HomeProvider.branchLong),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
  );

  Marker userLocationMarker = Marker(
    markerId: MarkerId('main-marker'),
    position: LatLng(AppProvider.latitude, AppProvider.longitude),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HomePage.sliderHeight,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: initCameraPosition, zoom: defaultZoom),
            mapType: MapType.normal,
            markers: {userLocationMarker, branchMarker},
            compassEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            indoorViewEnabled: false,
            onMapCreated: _onMapCreated,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Container(
                //TODO: Add shadow
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Text('Minimum ', style: AppTextStyles.subtitleXs),
                          Expanded(
                            child: Html(
                              data: """${homeProvider.homeData.branch.minimumOrder.formatted}""",
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
                        children: [
                          Text('Delivery ', style: AppTextStyles.subtitleXs),
                          Expanded(
                            child: Html(
                              data: """${homeProvider.homeData.branch.fixedDeliveryFee.formatted}""",
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
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final CameraPosition _cameraPosition = CameraPosition(
      target: initCameraPosition,
      zoom: defaultZoom,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    _controller.complete(controller);
  }
}

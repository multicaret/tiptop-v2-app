import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/home_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

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
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: initCameraPosition, zoom: defaultZoom),
        mapType: MapType.normal,
        markers: {userLocationMarker, branchMarker},
        compassEnabled: false,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        indoorViewEnabled: false,
        onMapCreated: _onMapCreated,
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

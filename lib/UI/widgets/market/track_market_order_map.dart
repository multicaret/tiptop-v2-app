import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

class TrackMarketOrderMap extends StatefulWidget {
  @override
  _TrackMarketOrderMapState createState() => _TrackMarketOrderMapState();
}

class _TrackMarketOrderMapState extends State<TrackMarketOrderMap> {
  double centerLat;
  double centerLong;

  double defaultZoom = 12.0;
  LatLng initCameraPosition = LatLng(
    (MarketProvider.marketBranchLat + AppProvider.latitude) / 2,
    (MarketProvider.marketBranchLong + AppProvider.longitude) / 2,
  );

  Marker homeMarker;
  Marker marketMarker;
  List<Marker> allMarkers = [];

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(target: initCameraPosition, zoom: defaultZoom),
      mapType: MapType.normal,
      markers: Set.from(allMarkers),
      onMapCreated: _onMapCreated,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    Uint8List homeMarkerIconBytes = await getBytesFromAsset('assets/images/address-home-marker-icon.png');
    Uint8List marketMarkerIconBytes = await getBytesFromAsset('assets/images/delivery-marker-icon.png');

    setState(() {
      homeMarker = Marker(
        markerId: MarkerId('Home'),
        draggable: false,
        icon: BitmapDescriptor.fromBytes(homeMarkerIconBytes),
        position: LatLng(AppProvider.latitude, AppProvider.longitude),
      );
      marketMarker = Marker(
        markerId: MarkerId('Market'),
        draggable: false,
        icon: BitmapDescriptor.fromBytes(marketMarkerIconBytes),
        position: LatLng(MarketProvider.marketBranchLat, MarketProvider.marketBranchLong),
      );
      // add marker
      allMarkers.add(homeMarker);
      allMarkers.add(marketMarker);
    });
  }
}

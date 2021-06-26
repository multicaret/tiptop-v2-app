import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

class TrackFoodOrderMap extends StatefulWidget {
  final Branch restaurant;

  TrackFoodOrderMap({@required this.restaurant});

  @override
  _TrackFoodOrderMapState createState() => _TrackFoodOrderMapState();
}

class _TrackFoodOrderMapState extends State<TrackFoodOrderMap> {
  double centerLat;
  double centerLong;

  double defaultZoom = 12.0;
  LatLng initCameraPosition;

  Marker homeMarker;
  Marker foodMarker;
  List<Marker> allMarkers = [];

  @override
  Widget build(BuildContext context) {
    initCameraPosition = LatLng((widget.restaurant.latitude + AppProvider.latitude) / 2, (widget.restaurant.longitude + AppProvider.longitude) / 2);
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
    Uint8List foodMarkerIconBytes = await getBytesFromAsset('assets/images/delivery-marker-icon.png');

    setState(() {
      homeMarker = Marker(
        markerId: MarkerId('Home'),
        draggable: false,
        icon: BitmapDescriptor.fromBytes(homeMarkerIconBytes),
        position: LatLng(AppProvider.latitude, AppProvider.longitude),
      );
      foodMarker = Marker(
        markerId: MarkerId('food'),
        draggable: false,
        icon: BitmapDescriptor.fromBytes(foodMarkerIconBytes),
        position: LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
      );
      // add marker
      allMarkers.add(homeMarker);
      allMarkers.add(foodMarker);
    });
  }
}

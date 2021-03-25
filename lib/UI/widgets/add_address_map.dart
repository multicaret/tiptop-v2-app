import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

class AddAddressMap extends StatefulWidget {
  final double defaultZoom;
  final String customMarkerIcon;
  final Function setMarkersArray;
  final List<Marker> markers;
  final LatLng pickedPosition;
  final Function setPickedPosition;
  final Function onCameraMoveStarted;
  final Marker defaultMarker;

  AddAddressMap({
    this.defaultZoom = 12,
    this.customMarkerIcon,
    this.setMarkersArray,
    this.markers,
    this.pickedPosition,
    this.setPickedPosition,
    this.onCameraMoveStarted,
    this.defaultMarker,
  });

  @override
  _AddAddressMapState createState() => _AddAddressMapState();
}

class _AddAddressMapState extends State<AddAddressMap> {
  static LatLng _defaultMarkerPosition = LatLng(AppProvider.latitude, AppProvider.longitude);
  Marker defaultMarker;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _defaultMarkerPosition,
        zoom: widget.defaultZoom,
      ),
      mapType: MapType.normal,
      markers: Set.from(widget.markers),
      onMapCreated: _onMapCreated,
      onCameraMove: (_position) => _updatePosition(_position),
      onCameraMoveStarted: widget.onCameraMoveStarted,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    if (AppProvider.latitude == null || AppProvider.longitude == null) {
      bool isEnabled = await handleLocationPermission();
      if (!isEnabled) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(LocationPermissionPage.routeName);
      }
    }
    final userLocation = LatLng(AppProvider.latitude, AppProvider.longitude);
    widget.setPickedPosition(userLocation);
    final CameraPosition _cameraPosition = CameraPosition(
      target: userLocation,
      zoom: widget.defaultZoom,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    _defaultMarkerPosition = LatLng(AppProvider.latitude, AppProvider.longitude);

    if (widget.customMarkerIcon != null) {
      Uint8List markerIconBytes = await getAndCacheMarkerIcon(widget.customMarkerIcon);
      defaultMarker = Marker(
        markerId: MarkerId('main-marker'),
        position: _defaultMarkerPosition,
        icon: BitmapDescriptor.fromBytes(markerIconBytes),
      );
      widget.setMarkersArray([defaultMarker]);
    }
  }

  void _updatePosition(CameraPosition _position) {
    LatLng newMarkerPosition = LatLng(_position.target.latitude, _position.target.longitude);

    double pickedLat = newMarkerPosition.latitude;
    double pickedLng = newMarkerPosition.longitude;
    widget.setPickedPosition(LatLng(pickedLat, pickedLng));

    if (defaultMarker != null) {
      defaultMarker = defaultMarker.copyWith(positionParam: widget.pickedPosition);
      widget.setMarkersArray([defaultMarker]);
    }
  }
}

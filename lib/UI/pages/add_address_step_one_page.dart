import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

class AddAddressStepOnePage extends StatefulWidget {
  static const routeName = '/add-address-step-one';

  @override
  _AddAddressStepOnePageState createState() => _AddAddressStepOnePageState();
}

class _AddAddressStepOnePageState extends State<AddAddressStepOnePage> {
  bool _isInit = true;
  BitmapDescriptor currentLocationIcon;
  List<Marker> markers = [];
  AddressesProvider addressesProvider;
  Kind selectedKind;

  static LatLng _defaultMarkerPosition = LatLng(AppProvider.latitude, AppProvider.longitude);
  double defaultZoom = 12.0;

  Marker defaultMarker;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      addressesProvider = Provider.of<AddressesProvider>(context);
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      selectedKind = data['kind'];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Add New Address')),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _defaultMarkerPosition,
                zoom: defaultZoom,
              ),
              mapType: MapType.normal,
              markers: Set.from(markers),
              onMapCreated: _onMapCreated,
              onCameraMove: ((_position) => _updatePosition(_position)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(AppProvider.latitude, AppProvider.longitude),
      zoom: defaultZoom,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    Uint8List markerIconBytes = await getAndCacheMarkerIcon(selectedKind.markerIcon);
    defaultMarker = Marker(
      markerId: MarkerId('main-marker'),
      position: _defaultMarkerPosition,
      icon: BitmapDescriptor.fromBytes(markerIconBytes),
    );
    setState(() {
      _defaultMarkerPosition = LatLng(AppProvider.latitude, AppProvider.longitude);
      markers = [defaultMarker];
    });
  }

  LatLng pickedPosition;

  void _updatePosition(CameraPosition _position) {
    LatLng newMarkerPosition = LatLng(_position.target.latitude, _position.target.longitude);

    double pickedLat = newMarkerPosition.latitude;
    double pickedLong = newMarkerPosition.longitude;

    setState(() {
      pickedPosition = LatLng(pickedLat, pickedLong);
      defaultMarker = defaultMarker.copyWith(positionParam: pickedPosition);
      if (defaultMarker != null) {
        markers = [defaultMarker];
      }
    });
  }
}

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import 'add_address_step_two_page.dart';

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
  LatLng pickedPosition;

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
          Positioned(
            bottom: 115,
            right: 0,
            left: 0,
            top: 0,
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 17, right: 17, top: 20, bottom: 40),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.shadowDark, blurRadius: 6)],
                color: AppColors.white,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondaryDark,
                  onPrimary: AppColors.primary,
                ),
                onPressed: _submitAddressLocation,
                child: Text(Translations.of(context).get('Use This Address')),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submitAddressLocation() {
    showDialog(
      context: context,
      builder: (context) => ConfirmAlertDialog(
        image: 'assets/images/map-and-marker.png',
        title: 'Your order will be delivered to the pinned location on the map, please confirm your pinned location',
      ),
    ).then((response) {
      if (response != null && response) {
        Navigator.of(context, rootNavigator: true).pushNamed(
          AddAddressStepTwoPage.routeName,
          arguments: {
            'pickedPosition': pickedPosition,
          },
        );
      }
    });
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

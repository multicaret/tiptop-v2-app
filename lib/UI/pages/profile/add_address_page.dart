import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/address/add_address_map.dart';
import 'package:tiptop_v2/UI/widgets/address/address_details_form.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AddAddressPage extends StatefulWidget {
  static const routeName = '/add-address-step-one';
  static double addressDetailsFormContainerHeight = 320.0;

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final GlobalKey<FormState> addressDetailsFormKey = GlobalKey();
  bool _isInit = true;
  bool _isLoadingStoreAddressRequest = false;
  bool _isLoadingCreateAddressRequest = false;

  Kind selectedKind;
  String currentMarkerIcon;

  AddressesProvider addressesProvider;
  AppProvider appProvider;

  List<Marker> markers = [];
  LatLng pickedPosition;

  bool addressLocationConfirmed = false;
  double useAddressButtonHeight = 115.0;

  City selectedCity;
  Region selectedRegion;
  CreateAddressData createAddressData;

  Marker defaultMarker;

  Future<bool> _createAddress() async {
    setState(() => _isLoadingCreateAddressRequest = true);
    try {
      final createAddressResponse = await addressesProvider.createAddress(appProvider, pickedPosition);
      if (createAddressResponse == 401) {
        showToast(msg: 'You need to log in first!');
        Navigator.of(context, rootNavigator: true).pushNamed(WalkthroughPage.routeName);
        return false;
      }
      createAddressData = addressesProvider.createAddressData;
      selectedCity = addressesProvider.createAddressData.selectedCity;
      selectedRegion = addressesProvider.createAddressData.selectedRegion;
      setState(() {
        //Todo: find a way to save user data
        addressDetailsFormData = {
          'kind': selectedKind.id,
          'alias': selectedKind.title,
          'region_id': selectedRegion.id,
          'city_id': selectedCity.id,
          'address1': '',
          'latitude': pickedPosition.latitude,
          'longitude': pickedPosition.longitude,
          'notes': '',
        };
      });
      print(addressDetailsFormData);
      setState(() => _isLoadingCreateAddressRequest = false);
      return true;
    } catch (e) {
      // throw e;
      showToast(msg: 'An error occurred!');
      setState(() => _isLoadingCreateAddressRequest = false);
      return false;
    }
  }

  Map<String, dynamic> addressDetailsFormData = {
    'kind': null,
    'alias': '',
    'region_id': null,
    'city_id': null,
    'address1': '',
    'latitude': '',
    'longitude': '',
    'notes': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      addressesProvider = Provider.of<AddressesProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      selectedKind = data['kind'];
      currentMarkerIcon = selectedKind.markerIcon;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _switchToLocationSelect() {
    addressDetailsFormKey.currentState.reset();
    setState(() {
      addressLocationConfirmed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasOverlayLoader: _isLoadingStoreAddressRequest,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Add New Address')),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: useAddressButtonHeight,
            right: 0,
            left: 0,
            top: 0,
            child: AddAddressMap(
              setMarkersArray: (_markers) => setState(() => markers = _markers),
              setPickedPosition: (_pickedPosition) => setState(() => pickedPosition = _pickedPosition),
              setDefaultMarker: (_defaultMarker) => setState(() => defaultMarker = _defaultMarker),
              defaultMarker: defaultMarker,
              onCameraMoveStarted: _switchToLocationSelect,
              customMarkerIcon: selectedKind.markerIcon,
              markers: markers,
              pickedPosition: pickedPosition,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 17, right: 17, top: 20, bottom: 40),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                color: AppColors.white,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondaryDark,
                  onPrimary: AppColors.primary,
                ),
                onPressed: _submitAddressLocation,
                child: _isLoadingCreateAddressRequest
                    ? SpinKitThreeBounce(
                        color: AppColors.primary,
                        size: 30,
                      )
                    : Text(Translations.of(context).get('Use This Address')),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: addressLocationConfirmed ? 0 : -AddAddressPage.addressDetailsFormContainerHeight,
            right: 0,
            left: 0,
            height: AddAddressPage.addressDetailsFormContainerHeight,
            child: AddressDetailsForm(
              formKey: addressDetailsFormKey,
              addressDetailsFormData: addressDetailsFormData,
              selectedKind: selectedKind,
              submitForm: submitAddressDetailsForm,
              createAddressData: createAddressData,
              setRegionId: (id) => setState(() => addressDetailsFormData['region_id'] = id),
              setCityId: (id) => setState(() => addressDetailsFormData['city_id'] = id),
              setKindId: (id) {
                setState(() {
                  addressDetailsFormData['kind'] = id;
                  addressDetailsFormData['alias'] = createAddressData.kinds.firstWhere((kind) => kind.id == id).title;
                  currentMarkerIcon = createAddressData.kinds.firstWhere((kind) => kind.id == id).markerIcon;
                });
                getAndCacheMarkerIcon(currentMarkerIcon).then((Uint8List markerIconBytes) {
                  setState(() {
                    defaultMarker = defaultMarker.copyWith(iconParam: BitmapDescriptor.fromBytes(markerIconBytes));
                    markers = [defaultMarker];
                  });
                });
                // print(addressDetailsFormData);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _submitAddressLocation() async {
    final dialogResponse = await showDialog(
      context: context,
      builder: (context) => ConfirmAlertDialog(
        image: 'assets/images/map-and-marker.png',
        title: 'Your order will be delivered to the pinned location on the map, please confirm your pinned location',
      ),
    );
    if (dialogResponse != null && dialogResponse) {
      print(pickedPosition);
      final response = await _createAddress();
      if (response) {
        setState(() => addressLocationConfirmed = true);
      }
    }
  }

  Future<void> submitAddressDetailsForm() async {
    if (!addressDetailsFormKey.currentState.validate()) {
      showToast(msg: Translations.of(context).get('Invalid Form'));
      return;
    }
    addressDetailsFormKey.currentState.save();
    print(addressDetailsFormData);
    setState(() => _isLoadingStoreAddressRequest = true);
    await addressesProvider.storeAddress(appProvider, addressDetailsFormData);
    setState(() => _isLoadingStoreAddressRequest = false);
    showToast(msg: 'Address stored successfully!');
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
  }
}

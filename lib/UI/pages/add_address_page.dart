import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/add_address_map.dart';
import 'package:tiptop_v2/UI/widgets/address_details_form.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AddAddressPage extends StatefulWidget {
  static const routeName = '/add-address-step-one';

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final GlobalKey<FormState> addressDetailsFormKey = GlobalKey();
  bool _isInit = true;
  Kind selectedKind;

  AddressesProvider addressesProvider;
  AppProvider appProvider;

  List<Marker> markers = [];
  LatLng pickedPosition;
  Marker defaultMarker;

  bool addressLocationConfirmed = false;
  double useAddressButtonHeight = 115.0;
  double addressDetailsFormContainerHeight = 300.0;
  bool _isLoadingCreateAddressRequest = false;

  List<City> cities = [];
  List<Region> regions = [];
  City selectedCity;
  Region selectedRegion;

  Future<bool> _createAddress() async {
    setState(() => _isLoadingCreateAddressRequest = true);
    try {
      final createAddressResponse = await addressesProvider.createAddress(appProvider, pickedPosition);
      if (createAddressResponse == 401) {
        showToast(msg: 'You need to log in first!');
        Navigator.of(context, rootNavigator: true).pushNamed(WalkthroughPage.routeName);
        return false;
      }
      cities = addressesProvider.cities;
      regions = addressesProvider.regions;
      selectedCity = addressesProvider.selectedCity;
      selectedRegion = addressesProvider.selectedRegion;
      setState(() => _isLoadingCreateAddressRequest = false);
      return true;
    } catch (e) {
      showToast(msg: 'An error occurred!');
      setState(() => _isLoadingCreateAddressRequest = false);
      return false;
    }
  }

  Map<String, dynamic> addressDetailsFormData = {
    'kind': '',
    'alias': '',
    'region_id': '',
    'city_id': '',
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
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _switchToLocationSelect() {
    //User started moving the map while in form view
    LatLng _currentPickedPosition = pickedPosition;
    addressDetailsFormKey.currentState.save();
    if (!addressDetailsFormData['address1'].isEmpty || !addressDetailsFormData['notes'].isEmpty) {
      //User has entered data in the form
      showDialog(
        context: context,
        builder: (context) => ConfirmAlertDialog(
          title: 'Are you sure you want to change your pin location? Your entered data will be lost',
        ),
      ).then((response) {
        if (response != null && response) {
          //User agreed to reset data and change pin
          setState(() {
            addressLocationConfirmed = false;
            addressDetailsFormData = {
              'kind': '',
              'alias': '',
              'region_id': '',
              'city_id': '',
              'address1': '',
              'latitude': '',
              'longitude': '',
              'notes': '',
            };
          });
        } else {
          //User disagreed, return the pin to the previous position
          setState(() {
            if (defaultMarker != null) {
              defaultMarker = defaultMarker.copyWith(positionParam: _currentPickedPosition);
              markers = [defaultMarker];
            }
            pickedPosition = _currentPickedPosition;
          });
        }
      });
    } else {
      setState(() {
        addressLocationConfirmed = false;
      });
    }
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
            bottom: useAddressButtonHeight,
            right: 0,
            left: 0,
            top: 0,
            child: AddAddressMap(
              setMarkersArray: (_markers) => setState(() => markers = _markers),
              setPickedPosition: (_pickedPosition) => setState(() => pickedPosition = _pickedPosition),
              customMarkerIcon: selectedKind.markerIcon,
              markers: markers,
              pickedPosition: pickedPosition,
              onCameraMoveStarted: _switchToLocationSelect,
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
            bottom: addressLocationConfirmed ? 0 : -addressDetailsFormContainerHeight,
            right: 0,
            left: 0,
            height: addressDetailsFormContainerHeight,
            child: Container(
              height: addressDetailsFormContainerHeight,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.shadowDark, blurRadius: 6)],
                color: AppColors.white,
              ),
              child: AddressDetailsForm(
                formKey: addressDetailsFormKey,
                addressDetailsFormData: addressDetailsFormData,
                selectedKind: selectedKind,
              ),
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
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

import 'local_storage.dart';

class AddressesProvider with ChangeNotifier {
  CreateAddressResponseData createAddressResponseData;
  CreateAddressData createAddressData;

  AddressesResponseData addressesResponseData;
  List<Address> addresses = [];
  List<Kind> kinds = [];

  LocalStorage storageActions = LocalStorage.getActions();

  bool addressIsSelected = false;
  Address selectedAddress;

  Future<void> fetchSelectedAddress() async {
    bool checkSelectedAddressKey = storageActions.checkKey(key: 'selected_address');
    if (!checkSelectedAddressKey) {
      print('Address not selected yet!');
      addressIsSelected = false;
      notifyListeners();
      return;
    }
    String selectedAddressString = await storageActions.getDataOfType(key: 'selected_address', type: String);
    print(selectedAddressString);
    selectedAddress = Address.fromJson(json.decode(selectedAddressString));
    addressIsSelected = true;
    notifyListeners();
  }

  Future<dynamic> createAddress(AppProvider appProvider, LatLng pickedPosition) async {
    final endpoint = 'profile/addresses/create';

    Map<String, String> body = {
      'latitude': '${pickedPosition.latitude}',
      'longitude': '${pickedPosition.longitude}',
    };

    final responseData = await appProvider.get(endpoint: endpoint, body: body, withToken: true);

    if (responseData == 401) {
      return 401;
    }

    createAddressResponseData = CreateAddressResponseData.fromJson(responseData);

    if (createAddressResponseData.createAddressData == null || createAddressResponseData.status != 200) {
      throw HttpException(title: 'Error', message: createAddressResponseData.message);
    }

    createAddressData = createAddressResponseData.createAddressData;

    notifyListeners();
  }

  Future<dynamic> fetchAndSetAddresses(AppProvider appProvider) async {
    final endpoint = 'profile/addresses';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: true);
    addressesResponseData = AddressesResponseData.fromJson(responseData);

    if (responseData == 401) {
      return 401;
    }

    if (addressesResponseData.addressesData == null || addressesResponseData.status != 200) {
      throw HttpException(title: 'Error', message: addressesResponseData.message);
    }

    addresses = addressesResponseData.addressesData.addresses;
    kinds = addressesResponseData.addressesData.kinds;
    notifyListeners();
  }
}

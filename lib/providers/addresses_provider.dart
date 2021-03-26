import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiptop_v2/models/address.dart';
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

  bool get addressIsSelected => selectedAddress != null;
  Address selectedAddress;

  Future<void> fetchSelectedAddress() async {
    bool checkSelectedAddressKey = storageActions.checkKey(key: 'selected_address');
    if (!checkSelectedAddressKey) {
      print('Address not selected yet!');
      selectedAddress = null;
      // notifyListeners();
      return;
    }
    print('Address is selected!');
    String selectedAddressString = await storageActions.getDataOfType(key: 'selected_address', type: String);
    selectedAddress = Address.fromJson(json.decode(selectedAddressString));
    notifyListeners();
  }

  Future<void> changeSelectedAddress(Address _selectedAddress) async {
    try {
      String selectedAddressString = json.encode(_selectedAddress.toJson());
      selectedAddress = _selectedAddress;
      await storageActions.save(key: 'selected_address', data: selectedAddressString);
      notifyListeners();
    } catch (e) {
      print('error saving address!');
      throw e;
    }
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

  Future<dynamic> storeAddress(AppProvider appProvider, Map<String, dynamic> addressDetails) async {
    final endpoint = 'profile/addresses';
    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: addressDetails,
      withToken: true,
    );

    if (responseData == 401) {
      return 401;
    }

    if (responseData["data"] == null || responseData["status"] != 200) {
      throw HttpException(title: 'Error', message: responseData["message"] ?? 'Unknown');
    }

    selectedAddress = Address.fromJson(responseData["data"]["address"]);
    String selectedAddressString = json.encode(responseData["data"]["address"]);
    try {
      await storageActions.save(key: 'selected_address', data: selectedAddressString);
      print('saved address!');
      notifyListeners();
    } catch (e) {
      print('error saving address!');
      throw e;
    }
  }

  Future<dynamic> deleteAddress(AppProvider appProvider, int addressId) async {
    final endpoint = 'profile/addresses/$addressId/delete';
    final responseData = await appProvider.post(endpoint: endpoint);
    if(responseData == 401) {
      return 401;
    }
    if(responseData["status"] != 200) {
      throw HttpException(title: 'Error', message: responseData["message"] ?? 'Unknown');
    }
    if(selectedAddress != null && selectedAddress.id == addressId) {
      print('😱😱😱😱 Ya Lahweeee you are deleting selected address');
      storageActions.deleteData(key: 'selected_address');
      selectedAddress = null;
    }
  }
}

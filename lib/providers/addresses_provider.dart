import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

import 'local_storage.dart';

class AddressesProvider with ChangeNotifier {
  CreateAddressData createAddressData;

  List<Address> addresses = [];
  List<Kind> kinds = [];

  LocalStorage storageActions = LocalStorage.getActions();

  bool get addressIsSelected => selectedAddress != null;
  Address selectedAddress;
  static int selectedAddressId;

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
    // print(selectedAddressString);
    selectedAddress = Address.fromJson(json.decode(selectedAddressString));
    selectedAddressId = selectedAddress.id;
    print('Selected Address ID: ${selectedAddress.id}, Name: ${selectedAddress.alias}');
    notifyListeners();
  }

  Future<void> changeSelectedAddress(Address _selectedAddress, {bool shouldClearExistingCart = false}) async {
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

    createAddressData = CreateAddressData.fromJson(responseData["data"]);
    notifyListeners();
  }

  Future<dynamic> fetchAndSetAddresses(AppProvider appProvider) async {
    final endpoint = 'profile/addresses';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: true);
    if (responseData == 401) {
      return 401;
    }

    AddressesData addressesData = AddressesData.fromJson(responseData["data"]);
    addresses = addressesData.addresses;
    kinds = addressesData.kinds;
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
    if (responseData == 401) {
      return 401;
    }
    if (responseData["message"] != null) {
      return responseData["message"];
    }
    if (selectedAddress != null && selectedAddress.id == addressId) {
      print('😱😱😱😱 Ya Lahweeee you are deleting selected address');
      storageActions.deleteData(key: 'selected_address');
      selectedAddressId = null;
      selectedAddress = null;
    }
  }
}

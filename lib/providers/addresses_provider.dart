import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class AddressesProvider with ChangeNotifier {
  CreateAddressResponseData createAddressResponseData;
  CreateAddressData createAddressData;

  List<City> cities = [];
  List<Region> regions = [];
  City selectedCity;
  Region selectedRegion;

  AddressesResponseData addressesResponseData;
  List<Address> addresses = [];
  List<Kind> kinds = [];

  Future<dynamic> createAddress(AppProvider appProvider, {double lat, double long}) async {
    final endpoint = 'profile/addresses/create';

    Map<String, String> body = {
      'latitude': '$lat',
      'longitude': '$long',
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
    cities = createAddressData.cities;
    regions = createAddressData.regions;
    selectedCity = createAddressData.selectedCity;
    selectedRegion = createAddressData.selectedRegion;

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

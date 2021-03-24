import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class AddressesProvider with ChangeNotifier {
  List<City> cities = [];
  List<Region> regions = [];
  City selectedCity;
  Region selectedRegion;

  CreateAddressResponseData createAddressResponseData;
  CreateAddressData createAddressData;

  Future<dynamic> createAddress(AppProvider appProvider, {double lat, double long}) async {
    final endpoint = 'profile/addresses/create';

    Map<String, String> body = {
      'latitude': '$lat',
      'longitude': '$long',
    };

    final responseData = await appProvider.get(endpoint: endpoint, body: body, withToken: true);

    if(responseData == 401) {
      return 401;
    }

    createAddressResponseData = CreateAddressResponseData.fromJson(responseData);

    if(createAddressResponseData.createAddressData == null || createAddressResponseData.status != 200) {
      throw HttpException(title: 'Error', message: createAddressResponseData.message);
    }

    createAddressData = createAddressResponseData.createAddressData;
    cities = createAddressData.cities;
    regions = createAddressData.regions;
    selectedCity = createAddressData.selectedCity;
    selectedRegion = createAddressData.selectedRegion;

    notifyListeners();
  }
}
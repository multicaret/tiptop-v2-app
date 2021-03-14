import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class HomeProvider with ChangeNotifier {
  HomeDataResponse homeDataResponse;
  HomeData homeData;
  List<Category> categories;

  Future<void> fetchAndSetHomeData() async {
    final endpoint = 'home';
    final body = {
      'latitude': '${AppProvider.latitude}',
      'longitude': '${AppProvider.longitude}',
      'channel': 'grocery',
      'selected_address_id': '1',
    };

    try {
      final responseData = await AppProvider().get(
        endpoint: endpoint,
        body: body,
      );

      homeDataResponse = homeDataResponseFromJson(json.encode(responseData));

      if (homeDataResponse.homeData == null || homeDataResponse.status != 200) {
        throw HttpException(title: 'Error', message: homeDataResponse.message);
      }

      homeData = homeDataResponse.homeData;
      categories = homeData.categories;

    } catch (error) {
      throw error;
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/search.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'cart_provider.dart';
import 'home_provider.dart';
import 'local_storage.dart';

class SearchProvider with ChangeNotifier {
  List<Term> terms = [];

  Future<void> fetchAndSetSearchTerms({HomeProvider homeProvider}) async {
    final endpoint = 'search';
    final Map<String, String> body = {
      'branch_id': homeProvider.branchId.toString(),
      'chain_id': homeProvider.chainId.toString(),
    };
    final responseData = await AppProvider().get(endpoint: endpoint, body: body);
    var searchResponse = SearchResponse.fromJson(responseData);
    if (searchResponse.search == null || searchResponse.status != 200) {
      notifyListeners();
      throw HttpException(title: 'Error', message: searchResponse.message);
    }

    terms = searchResponse.search.terms;
    notifyListeners();
  }
}

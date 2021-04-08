import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/search.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

import 'home_provider.dart';

class SearchProvider with ChangeNotifier {
  List<Term> terms = [];

  Future<void> fetchAndSetSearchTerms() async {
    final endpoint = 'search';
    final Map<String, String> body = {
      'branch_id': HomeProvider.branchId.toString(),
      'chain_id': HomeProvider.chainId.toString(),
    };
    final responseData = await AppProvider().get(endpoint: endpoint, body: body);
    Search search = Search.fromJson(responseData["data"]);
    terms = search.terms;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/search.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';

class SearchProvider with ChangeNotifier {
  List<Term> foodSearchTerms = [];
  List<Term> marketSearchTerms = [];
  bool isLoadingSearchTerms = false;

  Future<void> fetchAndSetSearchTerms({@required AppChannel selectedChannel}) async {
    final endpoint = 'search';
    final Map<String, String> body = {
      'channel': appChannelValues.reverse[selectedChannel],
    };
    final Map<String, String> marketSearchBody = {
      'branch_id': MarketProvider.branchId.toString(),
      'chain_id': MarketProvider.chainId.toString(),
    };
    if (selectedChannel == AppChannel.MARKET) {
      body.addAll(marketSearchBody);
    }
    print('body');
    print(body);
    isLoadingSearchTerms = true;
    notifyListeners();
    final responseData = await AppProvider().get(endpoint: endpoint, body: body);
    Search search = Search.fromJson(responseData["data"]);
    if (selectedChannel == AppChannel.FOOD) {
      foodSearchTerms = search.terms;
    } else {
      marketSearchTerms = search.terms;
    }
    isLoadingSearchTerms = false;
    notifyListeners();
  }
}

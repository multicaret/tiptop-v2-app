import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_search_page.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/search.dart';
import 'package:tiptop_v2/providers/search_provider.dart';

import 'market/market_search_page.dart';

class SearchPage extends StatefulWidget {
  final AppChannel currentAppChannel;
  static const routeName = '/food-search';

  SearchPage({this.currentAppChannel});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchProvider searchProvider;
  List<Term> searchTerms = [];
  bool isLoadingFoodSearchTerms = false;

  Future<void> _fetchAndSetSearchTerms() async {
    await searchProvider.fetchAndSetSearchTerms(selectedChannel: AppChannel.MARKET);
    await searchProvider.fetchAndSetSearchTerms(selectedChannel: AppChannel.FOOD);
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    print("Hello");
    if (_isInit) {
      searchProvider = Provider.of<SearchProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAndSetSearchTerms();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: widget.currentAppChannel == AppChannel.FOOD
          ? FoodSearchPage(
              onSearchSubmitted: _fetchAndSetSearchTerms,
            )
          : MarketSearchPage(
              onSearchSubmitted: _fetchAndSetSearchTerms,
            ),
    );
  }
}

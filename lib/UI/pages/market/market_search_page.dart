import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_search_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_products_grid_view.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/models/search.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/providers/search_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class MarketSearchPage extends StatefulWidget {
  static const routeName = '/market-search';

  @override
  _MarketSearchPageState createState() => _MarketSearchPageState();
}

class _MarketSearchPageState extends State<MarketSearchPage> {
  bool _isInit = true;
  bool _isLoading = false;

  String searchQuery = '';
  TextEditingController searchFieldController = new TextEditingController();
  FocusNode searchFieldFocusNode = new FocusNode();

  ProductsProvider productsProvider;
  SearchProvider searchProvider;
  HomeProvider homeProvider;

  List<Product> _searchedProducts = [];
  List<Term> _terms = [];

  @override
  void dispose() {
    searchFieldController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      searchProvider = Provider.of<SearchProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);

      fetchAndSetSearchTerms();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> fetchAndSetSearchTerms() async {
    setState(() => _isLoading = true);
    await searchProvider.fetchAndSetSearchTerms(selectedChannel: homeProvider.selectedChannel);
    _terms = searchProvider.terms;
    setState(() => _isLoading = false);
  }

  void _clearSearchResults() {
    searchFieldController.clear();
    searchFieldFocusNode.unfocus();
    setState(() {
      _searchedProducts = [];
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AppScaffold(
        hasCurve: false,
        appBar: AppBar(
          title: Text(Translations.of(context).get("Search")),
          actions: [
            if (_searchedProducts.isNotEmpty)
              IconButton(
                onPressed: _clearSearchResults,
                icon: AppIcons.icon(FontAwesomeIcons.eraser),
              )
          ],
        ),
        body: _isLoading
            ? const AppLoader()
            : Column(
                children: [
                  AppSearchField(
                    submitAction: (String searchQuery) => _submitSearch(searchQuery),
                    controller: searchFieldController,
                    focusNode: searchFieldFocusNode,
                  ),
                  _searchedProducts.isNotEmpty
                      ? SectionTitle(
                          'Search Results',
                          suffix: ' (${_searchedProducts.length})',
                        )
                      : SectionTitle('Most Searched Terms'),
                  _searchedProducts.isNotEmpty
                      ? Expanded(
                          child: Container(
                            color: AppColors.white,
                            child: MarketProductsGridView(
                              products: _searchedProducts,
                              physics: AlwaysScrollableScrollPhysics(),
                            ),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [..._getMostSearchedTermsList()],
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  List<Widget> _getMostSearchedTermsList() {
    return List.generate(
      _terms.length,
      (i) => Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () {
            searchFieldController.text = _terms[i].term;
            _submitSearch(_terms[i].term);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
            child: Row(
              children: [
                AppIcons.iconSecondary(FontAwesomeIcons.infoCircle),
                const SizedBox(width: 10),
                Text(_terms[i].term),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitSearch(String _searchQuery) async {
    print("_searchQuery");
    print(_searchQuery);
    if (searchQuery != _searchQuery) {
      setState(() {
        searchQuery = _searchQuery;
        _isLoading = true;
      });
      await productsProvider.fetchSearchedProducts(_searchQuery);
      _searchedProducts = productsProvider.searchedProducts;
      if (_searchedProducts.isEmpty) {
        showToast(msg: Translations.of(context).get("No results match your search"));
      } else {
        var key = 'Result${_searchedProducts.length > 1 ? "s" : ""} match your search';
        showToast(msg: '${_searchedProducts.length} ${Translations.of(context).get(key)}');
      }
      fetchAndSetSearchTerms();
      setState(() {
        _isLoading = false;
      });
    }
  }
}

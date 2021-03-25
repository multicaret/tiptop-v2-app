import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_search_field.dart';
import 'package:tiptop_v2/UI/widgets/products_grid_view.dart';
import 'package:tiptop_v2/UI/widgets/section_title.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  TextEditingController searchFieldController = new TextEditingController();
  FocusNode searchFieldFocusNote = new FocusNode();

  ProductsProvider productsProvider;
  List<Product> _products = [];
  bool _isLoading = false;

  @override
  void dispose() {
    searchFieldController.dispose();
    searchFieldFocusNote.dispose();
    super.dispose();
  }

  Future<void> _fetchProductsData(String _searchQuery) async {
    setState(() {
      _isLoading = true;
    });
    await productsProvider.fetchSearchedProducts(_searchQuery);
    _products = productsProvider.searchedProducts == null ? [] : productsProvider.searchedProducts;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  List<String> _terms = [
    'apple',
    'water',
    'banana',
  ];

  void _clearSearchResults() {
    searchFieldController.clear();
    searchFieldFocusNote.unfocus();
    setState(() {
      _products = [];
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    productsProvider = Provider.of<ProductsProvider>(context);
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Search')),
        actions: [
          if (_products.length > 0)
            IconButton(
              onPressed: _clearSearchResults,
              icon: AppIcon.icon(FontAwesomeIcons.eraser),
            )
        ],
      ),
      body: _isLoading
          ? AppLoader()
          : Column(
              children: [
                AppSearchField(
                  submitAction: (String searchQuery) => _mainSearch(searchQuery),
                  controller: searchFieldController,
                  focusNode: searchFieldFocusNote,
                ),
                _products.length >= 1
                    ? Expanded(
                        child: Container(
                          color: AppColors.white,
                          child: ProductsGridView(
                            products: _products,
                            physics: AlwaysScrollableScrollPhysics(),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SectionTitle('Most Searched Terms'),
                          ..._getMostSearchedTermsList(),
                        ],
                      ),
              ],
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
            searchFieldController.text = _terms[i];
            searchFieldFocusNote.requestFocus();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            child: Row(
              children: [
                AppIcon.iconSecondary(FontAwesomeIcons.infoCircle),
                SizedBox(width: 10),
                Text(_terms[i]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mainSearch(String _searchQuery) {
    print(_searchQuery);
    if (searchQuery != _searchQuery) {
      setState(() {
        searchQuery = _searchQuery;
      });
      _fetchProductsData(searchQuery).then((_) {
        if (_products.length == 0) {
          showToast(msg: Translations.of(context).get('No results match your search'));
        } else {
          var key = 'result${_products.length > 1 ? "s" : ""} match your search';
          showToast(msg: '${_products.length} ${Translations.of(context).get(key)}');
        }
      }).catchError((error) {
        print('@error Error');
        print(error);
        showToast(msg: error.message);
      });
    }
  }
}

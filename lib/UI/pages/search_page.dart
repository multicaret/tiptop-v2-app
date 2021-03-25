import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/product_item.dart';
import 'package:tiptop_v2/UI/widgets/products-screen/child_category_products.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';

  ProductsProvider productsProvider;
  List<Product> _products = [];
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    setState(() {
      _products = [];
    });
    print("Dispose Search");
  }


  Future<void> _fetchProductsData(String _searchQuery) async {
    setState(() {
      _isLoading = true;
    });
    await productsProvider.fetchSearchedProducts(_searchQuery);
    _products = productsProvider.searchedProducts;
    // Todo: for UI
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productsProvider = Provider.of<ProductsProvider>(context);
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Search')),
      ),
      body: _isLoading
          ? AppLoader()
          : Center(
              child: Column(
                children: [
                  AppTextField(
                    labelText: 'Quick Search',
                    hasInnerLabel: true,
                    prefixIconData: FontAwesomeIcons.search,
                    hasClearIcon: true,
                    required: true,
                    onFieldSubmitted: (String searchQuery) => _mainSearch(searchQuery),
                  ),
                  if (_products.length > 1) ProductsGridView(products: _products),
                ],
              ),
            ),
    );
  }

  void _mainSearch(String _searchQuery) {
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

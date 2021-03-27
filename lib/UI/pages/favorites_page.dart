import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/list_product_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';

class FavoritesPage extends StatefulWidget {
  static const routeName = '/favorites';

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _isInit = true;
  bool _isLoadingFavoriteProducts = false;

  ProductsProvider productsProvider;
  AppProvider appProvider;
  List<Product> favoriteProducts = [];

  Future<void> _fetchAndSetFavoriteProducts() async {
    setState(() => _isLoadingFavoriteProducts = true);
    await productsProvider.fetchAndSetFavoriteProducts(appProvider);
    favoriteProducts = productsProvider.favoriteProducts;
    setState(() => _isLoadingFavoriteProducts = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productsProvider = Provider.of<ProductsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      _fetchAndSetFavoriteProducts();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('My Favorites')),
      ),
      body: _isLoadingFavoriteProducts
          ? AppLoader()
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (c, i) => ListProductItem(product: favoriteProducts[i], hasControls: false,),
            ),
    );
  }
}

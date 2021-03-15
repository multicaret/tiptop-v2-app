import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  int selectedCategoryId;
  HomeProvider homeProvider;
  ProductsProvider productsProvider;
  List<Category> parents = [];
  List<Category> selectedParentSubCategories = [];

  Future<void> _fetchAndSetParentsAndProducts(int _selectedCategoryId) async {
    setState(() {
      _isLoading = true;
    });
    await productsProvider.fetchAndSetParentsAndProducts(_selectedCategoryId);
    parents = productsProvider.parents;
    selectedParentSubCategories = productsProvider.selectedParentSubCategories;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      homeProvider = Provider.of<HomeProvider>(context);
      productsProvider = Provider.of<ProductsProvider>(context);
      selectedCategoryId = homeProvider.selectedCategoryId;
      _fetchAndSetParentsAndProducts(selectedCategoryId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? AppLoader()
        : Center(
            child: Column(
              children: <Widget>[...parents.map((parent) => Text(parent.title))],
            ),
          );
  }
}

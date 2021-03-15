import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/child_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/parent_categories_tabs.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isInit = true;
  bool _isLoading = false;
  bool _isLoadingChildren = false;
  int selectedCategoryId;
  int _localSelectedCategoryId;

  HomeProvider homeProvider;
  ProductsProvider productsProvider;
  Category selectedParent;
  List<Category> parents = [];
  List<Category> selectedParentChildCategories = [];

  Future<void> _fetchAndSetParentsAndProducts(int _selectedCategoryId) async {
    setState(() {
      _isLoading = true;
    });
    await productsProvider.fetchAndSetParentsAndProducts(_selectedCategoryId);
    parents = productsProvider.parents;
    selectedParentChildCategories = productsProvider.selectedParentChildCategories;
    selectedParent = productsProvider.selectedParent;
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
      _localSelectedCategoryId = selectedCategoryId;
      _fetchAndSetParentsAndProducts(selectedCategoryId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? AppLoader()
        : Column(
            children: [
              ParentCategoriesTabs(
                action: (int parentId) {
                  homeProvider.selectCategory(parentId);
                  setState(() {
                    _localSelectedCategoryId = parentId;
                  });
                },
                selectedCategoryId: selectedCategoryId,
                //Todo: find a better way
                localSelectedCategoryId: _localSelectedCategoryId,
                parents: parents,
              ),
            ],
          );
  }
}

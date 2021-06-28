import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/market/cart/market_app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_category_tab_content.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';

class MarketProductsPage extends StatefulWidget {
  static const routeName = '/products';

  final int selectedParentCategoryId;
  final int selectedChildCategoryId;
  final bool isDeepLink;

  MarketProductsPage({
    @required this.selectedParentCategoryId,
    this.selectedChildCategoryId,
    this.isDeepLink = false,
  });

  @override
  _MarketProductsPageState createState() => _MarketProductsPageState();
}

class _MarketProductsPageState extends State<MarketProductsPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController parentCategoriesTabController;
  int currentTabIndex = 0;

  ProductsProvider productsProvider;

  int selectedParentIndex;

  bool _isInit = true;
  bool _isLoadingHomeAndProducts = false;

  List<Widget> parentCategoriesTabs = <Widget>[];

  List<Widget> getParentCategoriesTabs(List<Category> _parentCategories) {
    return List.generate(
      _parentCategories.length,
      (i) => Transform.translate(
        offset: Offset(0.0, 3.0),
        child: Tab(text: _parentCategories[i].title),
      ),
    );
  }

  Future<void> _fetchAndSetParentCategoriesAndProducts() async {
    setState(() => _isLoadingHomeAndProducts = true);
    await productsProvider.fetchAndSetParentCategoriesAndProducts();
    setState(() => _isLoadingHomeAndProducts = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productsProvider = Provider.of<ProductsProvider>(context);
      parentCategoriesTabController = TabController(length: parentCategoriesTabs.length, vsync: this);

      //These parent categories (without their children) are only used to set up the tab bar length and the initial category to scroll to
      List<Category> _parentCategories = productsProvider.marketParentCategoriesWithoutChildren;
      selectedParentIndex = _parentCategories.indexWhere((parent) => parent.id == widget.selectedParentCategoryId);
      parentCategoriesTabs = getParentCategoriesTabs(_parentCategories);
      parentCategoriesTabController = TabController(length: parentCategoriesTabs.length, vsync: this);
      if (selectedParentIndex != null && parentCategoriesTabController.length > 0) {
        parentCategoriesTabController.animateTo(selectedParentIndex);
      }

      //If opening the page from deeplink OR if the products request hasn't been run before, perform it then display the page
      //Another deeplink of another page might interrupt the running of the products request in the home page
      // if (!productsProvider.isLoadingFetchAllProductsRequest && productsProvider.marketParentCategories.length == 0) {
      //   _fetchAndSetParentCategoriesAndProducts();
      // }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    parentCategoriesTabController.dispose();
    // print('Disposed products page!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Category> marketParentCategories = productsProvider.marketParentCategories;

    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get("Products")),
        actions: [
          Consumer<AppProvider>(
            builder: (c, appProvider, _) => appProvider.isAuth
                ? MarketAppBarCartTotal(
                    isLoading: productsProvider.isLoadingFetchAllProductsRequest,
                    requestError: productsProvider.fetchAllProductsError,
                    isRTL: appProvider.isRTL,
                  )
                : Container(),
          ),
        ],
      ),
      body: Column(
        children: [
          ParentCategoriesTabs(
            parentCategoriesTabs: parentCategoriesTabs,
            selectedParentCategoryId: widget.selectedParentCategoryId,
            tabController: parentCategoriesTabController,
          ),
          Expanded(
            child: productsProvider.isLoadingFetchAllProductsRequest || _isLoadingHomeAndProducts
                ? AppLoader()
                : productsProvider.fetchAllProductsError
                    ? Center(child: Text(Translations.of(context).get("An Error Occurred!")))
                    : TabBarView(
                        controller: parentCategoriesTabController,
                        children: List.generate(marketParentCategories.length, (i) {
                          List<Category> childCategories =
                              marketParentCategories[i].childCategories.where((child) => child.products.length > 0).toList();

                          return ParentCategoryTabContent(
                            selectedParentCategoryId: marketParentCategories[i].id,
                            selectedChildCategoryId: widget.selectedChildCategoryId,
                            selectedParentCategoryEnglishTitle: marketParentCategories[i].englishTitle,
                            childCategories: childCategories,
                          );
                        }),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

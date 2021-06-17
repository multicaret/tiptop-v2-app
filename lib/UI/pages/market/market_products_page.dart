import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart/app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_category_tab_content.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
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

  AppProvider appProvider;
  ProductsProvider productsProvider;
  HomeProvider homeProvider;
  AddressesProvider addressesProvider;

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

  Future<void> fetchAndSetHomeDataAndProducts() async {
    setState(() => _isLoadingHomeAndProducts = true);
    await addressesProvider.fetchSelectedAddress();
    await homeProvider.fetchAndSetHomeData(context, appProvider);
    productsProvider.setMarketParentCategoriesWithoutChildren(homeProvider.marketParentCategoriesWithoutChildren);
    await productsProvider.fetchAndSetParentCategoriesAndProducts();
    setState(() => _isLoadingHomeAndProducts = false);
  }

  void _initTabBarSettings() {
    //If visited by deeplink,
    // Take market parent categories from freshly performed parent categories and products API request
    //If not visited by deeplink (home request was performed),
    // Take market parent categories fetched by home request
    List<Category> _parentCategories = widget.isDeepLink && productsProvider.marketParentCategories.length != 0
        ? productsProvider.marketParentCategories
        : productsProvider.marketParentCategoriesWithoutChildren;

    selectedParentIndex = _parentCategories.indexWhere((parent) => parent.id == widget.selectedParentCategoryId);

    parentCategoriesTabs = getParentCategoriesTabs(_parentCategories);
    parentCategoriesTabController = TabController(length: parentCategoriesTabs.length, vsync: this);
    if (selectedParentIndex != null && parentCategoriesTabController.length > 0) {
      parentCategoriesTabController.animateTo(selectedParentIndex);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productsProvider = Provider.of<ProductsProvider>(context);
      parentCategoriesTabController = TabController(length: parentCategoriesTabs.length, vsync: this);

      //If opening the page from deeplink & the home request hasn't been run before, perform it then display the page
      if (widget.isDeepLink && productsProvider.marketParentCategories.length == 0) {
        homeProvider = Provider.of<HomeProvider>(context);
        addressesProvider = Provider.of<AddressesProvider>(context);
        appProvider = Provider.of<AppProvider>(context);

        fetchAndSetHomeDataAndProducts().then((_) => _initTabBarSettings());
      } else {
        _initTabBarSettings();
      }
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
            builder: (c, appProvider, _) => appProvider.isAuth ? AppBarCartTotal() : Container(),
          ),
        ],
      ),
      body: _isLoadingHomeAndProducts
          ? AppLoader()
          : Column(
              children: [
                ParentCategoriesTabs(
                  parentCategoriesTabs: parentCategoriesTabs,
                  selectedParentCategoryId: widget.selectedParentCategoryId,
                  tabController: parentCategoriesTabController,
                ),
                Expanded(
                  child: productsProvider.isLoadingFetchAllProductsRequest
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

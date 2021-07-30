import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/market/cart/market_app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_category_products.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';

class MarketProductsPage extends StatefulWidget {
  static const routeName = '/products';

  final int selectedParentCategoryId;
  final int selectedChildCategoryId;
  final bool isDeepLink;

  // final List<Category> parentCategoriesWithoutChildren;

  MarketProductsPage({
    @required this.selectedParentCategoryId,
    this.selectedChildCategoryId,
    this.isDeepLink = false,
    // this.parentCategoriesWithoutChildren,
  });

  @override
  _MarketProductsPageState createState() => _MarketProductsPageState();
}

class _MarketProductsPageState extends State<MarketProductsPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController parentCategoriesTabController;
  int currentTabIndex = 0;

  ProductsProvider productsProvider;
  MarketProvider marketProvider;

  int selectedParentIndex;

  bool _isInit = true;
  List<Category> parentCategoriesWithoutChildren = <Category>[];

  List<Widget> getParentCategoriesTabs() {
    return List.generate(
      parentCategoriesWithoutChildren.length,
      (i) => Transform.translate(
        offset: Offset(0.0, 3.0),
        child: Tab(text: parentCategoriesWithoutChildren[i].title),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productsProvider = Provider.of<ProductsProvider>(context);
      marketProvider = Provider.of<MarketProvider>(context, listen: false);
      parentCategoriesWithoutChildren = marketProvider.marketParentCategoriesWithoutChildren;

      //These parent categories (without their children) are only used to set up the tab bar length and the initial category to scroll to
      parentCategoriesTabController = TabController(length: parentCategoriesWithoutChildren.length, vsync: this);

      selectedParentIndex = parentCategoriesWithoutChildren.indexWhere((parent) => parent.id == widget.selectedParentCategoryId);

      if (selectedParentIndex != null && parentCategoriesTabController.length > 0) {
        parentCategoriesTabController.animateTo(selectedParentIndex);
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
            parentCategoriesTabs: getParentCategoriesTabs(),
            selectedParentCategoryId: widget.selectedParentCategoryId,
            tabController: parentCategoriesTabController,
          ),
          Expanded(
            child: TabBarView(
              controller: parentCategoriesTabController,
              children: List.generate(getParentCategoriesTabs().length, (i) {
                return ParentCategoryProducts(
                  selectedParentCategoryId: parentCategoriesWithoutChildren[i].id,
                  selectedChildCategoryId: widget.selectedChildCategoryId,
                  selectedParentCategoryEnglishTitle: parentCategoriesWithoutChildren[i].englishTitle,
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

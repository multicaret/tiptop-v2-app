import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart/app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_category_tab_content.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';

class MarketProductsPage extends StatefulWidget {
  static const routeName = '/products';

  final List<Category> parentCategories;
  final int selectedParentCategoryId;

  MarketProductsPage({
    @required this.parentCategories,
    @required this.selectedParentCategoryId,
  });

  @override
  _MarketProductsPageState createState() => _MarketProductsPageState();
}

class _MarketProductsPageState extends State<MarketProductsPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  int currentTabIndex = 0;

  int selectedParentIndex;

  @override
  void initState() {
    selectedParentIndex = widget.parentCategories.indexWhere((parent) => parent.id == widget.selectedParentCategoryId);

    tabController = TabController(length: widget.parentCategories.length, vsync: this);
    tabController.animateTo(selectedParentIndex);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    print('Disposed products page!');
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
            builder: (c, appProvider, _) => appProvider.isAuth ? AppBarCartTotal() : Container(),
          ),
        ],
      ),
      body: Column(
        children: [
          ParentCategoriesTabs(
            parentCategories: widget.parentCategories,
            selectedParentCategoryId: widget.selectedParentCategoryId,
            tabController: tabController,
          ),
          Consumer<ProductsProvider>(
            builder: (c, productsProvider, _) {
              List<Category> marketParentCategories = productsProvider.marketParentCategories;

              return Expanded(
                child: productsProvider.isLoadingFetchAllProductsRequest
                    ? AppLoader()
                    : productsProvider.fetchAllProductsError
                        ? Center(child: Text(Translations.of(context).get("An Error Occurred!")))
                        : TabBarView(
                            controller: tabController,
                            children: List.generate(marketParentCategories.length, (i) {
                              List<Category> childCategories =
                                  marketParentCategories[i].childCategories.where((child) => child.products.length > 0).toList();

                              return ParentCategoryTabContent(
                                selectedParentCategoryId: marketParentCategories[i].id,
                                selectedParentCategoryEnglishTitle: marketParentCategories[i].englishTitle,
                                childCategories: childCategories,
                              );
                            }),
                          ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

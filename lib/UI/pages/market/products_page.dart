import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart/app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/market/products/parent_category_tab_content.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = '/products';

  final List<Category> parents;
  final int selectedParentCategoryId;
  final Function refreshHomeData;
  final bool isLoadingHomeData;

  ProductsPage({
    @required this.parents,
    @required this.selectedParentCategoryId,
    @required this.refreshHomeData,
    @required this.isLoadingHomeData,
  });

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  int currentTabIndex = 0;

  int selectedParentIndex;

  @override
  void initState() {
    selectedParentIndex = widget.parents.indexWhere((parent) => parent.id == widget.selectedParentCategoryId);

    tabController = TabController(length: widget.parents.length, vsync: this);
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
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Products')),
        actions: appProvider.isAuth ? [AppBarCartTotal(isLoadingHomeData: widget.isLoadingHomeData)] : null,
      ),
      body: Column(
        children: [
          ParentCategoriesTabs(
            parents: widget.parents,
            selectedParentCategoryId: widget.selectedParentCategoryId,
            tabController: tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: List.generate(widget.parents.length, (i) {
                bool hasChildCategories = widget.parents[i].hasChildren && widget.parents[i].childCategories.length != 0;
                List<Category> children = widget.parents[i].childCategories.where((child) => child.products.length > 0).toList();

                return hasChildCategories
                    ? ParentCategoryTabContent(
                        children: children,
                        refreshHomeData: widget.refreshHomeData,
                      )
                    : Center(
                        child: Text('No Sub Categories/Products'),
                      );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

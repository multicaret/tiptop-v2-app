import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/products-screen/parent_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/products-screen/parent_category_tab_content.dart';
import 'package:tiptop_v2/models/category.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = '/products';

  final List<Category> parents;
  final int selectedParentCategoryId;

  ProductsPage({
    @required this.parents,
    @required this.selectedParentCategoryId,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
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

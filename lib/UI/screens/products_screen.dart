import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/products-screen/parent_categories_tabs.dart';
import 'package:tiptop_v2/UI/widgets/products-screen/parent_category_tab_content.dart';
import 'package:tiptop_v2/models/category.dart';

class ProductsScreen extends StatefulWidget {
  final List<Category> parents;
  final int selectedParentCategoryId;

  ProductsScreen({
    @required this.parents,
    @required this.selectedParentCategoryId,
  });

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

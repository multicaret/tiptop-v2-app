import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/helper.dart';

import 'child_categories_tabs.dart';
import 'child_category_products.dart';

class ParentCategoryTabContent extends StatefulWidget {
  final List<Category> children;
  final Function refreshHomeData;

  ParentCategoryTabContent({
    @required this.children,
    @required this.refreshHomeData,
  });

  @override
  _ParentCategoryTabContentState createState() => _ParentCategoryTabContentState();
}

class _ParentCategoryTabContentState extends State<ParentCategoryTabContent> {
  bool _isInit = true;
  final selectedChildCategoryIdNotifier = ValueNotifier<int>(null);

  AutoScrollController childCategoriesScrollController;
  AutoScrollController productsScrollController;

  bool scrollIsAtTheTop = true;
  bool _isRefreshingData = false;
  List<Map<String, dynamic>> childCategoriesHeights;

  double productGridItemHeight = 0;

  Future<void> _refreshData() async {
    setState(() => _isRefreshingData = true);
    await widget.refreshHomeData();
    setState(() => _isRefreshingData = false);
  }

  @override
  void initState() {
    childCategoriesScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    productsScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );

    selectedChildCategoryIdNotifier.value = widget.children[0].id;
    super.initState();
  }

  void scrollToCategory(int index) {
    selectedChildCategoryIdNotifier.value = widget.children[index].id;
    childCategoriesScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  void scrollToProducts(int index) {
    selectedChildCategoryIdNotifier.value = widget.children[index].id;
    productsScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productGridItemHeight = (getColItemHeight(3, context) * 2);
      childCategoriesHeights = List.generate(widget.children.length, (i) {
        int rowsCount = (widget.children[i].products.length / 3).ceil();
        return {
          'id': widget.children[i].id,
          'height': (rowsCount * productGridItemHeight) + (10 * 2) + (10 * (rowsCount - 1)),
        };
      });
      print(childCategoriesHeights);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedChildCategoryIdNotifier,
          builder: (c, _selectedChildCategoryId, _) => ChildCategoriesTabs(
            children: widget.children,
            itemScrollController: childCategoriesScrollController,
            selectedChildCategoryId: _selectedChildCategoryId,
            //Fired when a child category is clicked
            action: (i) => scrollToProducts(i),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: _isRefreshingData
                ? Center(child: AppLoader())
                : ListView(
                    children: List.generate(
                      widget.children.length,
                      (i) => ChildCategoryProducts(
                        index: i,
                        count: widget.children.length,
                        child: widget.children[i],
                        productsScrollController: productsScrollController,
                        //Fired when a child category is scrolled into view
                        scrollSpyAction: (index) => scrollToCategory(index),
                        categoriesHeights: childCategoriesHeights,
                      ),
                    ),
                    controller: productsScrollController,
                  ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/models/category.dart';

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
  int selectedChildCategoryId;

  AutoScrollController childCategoriesScrollController;
  AutoScrollController productsScrollController;

  bool scrollIsAtTheTop = true;
  bool _isRefreshingData = false;

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

    selectedChildCategoryId = widget.children[0].id;
    super.initState();
  }

  void scrollToCategoryAndProducts(int index) {
    scrollToCategory(index);
    scrollToProducts(index);
  }

  void scrollToCategory(int index) {
    childCategoriesScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  void scrollToProducts(int index) {
    productsScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  void scrollSpy(int index) {
    setState(() {
      selectedChildCategoryId = widget.children[index].id;
    });
    scrollToCategory(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildCategoriesTabs(
          children: widget.children,
          itemScrollController: childCategoriesScrollController,
          selectedChildCategoryId: selectedChildCategoryId,
          action: (i) {
            //Todo: use provider/consumer to avoid entire widget tree rebuild
            setState(() {
              selectedChildCategoryId = widget.children[i].id;
            });
            scrollToProducts(i);
          },
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
                        scrollSpyAction: (index) => scrollSpy(index),
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

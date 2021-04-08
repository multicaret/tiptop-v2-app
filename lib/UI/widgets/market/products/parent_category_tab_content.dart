import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_vertical_content.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_products_grid_view.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/helper.dart';

import '../../UI/scrollable_horizontal_tabs.dart';

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

  @override
  void dispose() {
    print('disposing products page controllers');
    childCategoriesScrollController.dispose();
    productsScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productGridItemHeight = getProductGridItemHeight(context);
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
          builder: (c, _selectedChildCategoryId, _) => ScrollableHorizontalTabs(
            children: widget.children,
            itemScrollController: childCategoriesScrollController,
            selectedChildCategoryId: _selectedChildCategoryId,
            //Fired when a child category is clicked
            action: (index) {
              selectedChildCategoryIdNotifier.value = widget.children[index].id;
              scrollToCategory(index);
              scrollToProducts(index);
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: _isRefreshingData
                ? Center(child: AppLoader())
                : ListView.builder(
                    controller: productsScrollController,
                    itemCount: widget.children.length,
                    itemBuilder: (c, i) => ScrollableVerticalContent(
                      index: i,
                      count: widget.children.length,
                      child: widget.children[i],
                      scrollController: productsScrollController,
                      //Fired when a child category is scrolled into view
                      scrollSpyAction: (index) {
                        selectedChildCategoryIdNotifier.value = widget.children[index].id;
                        scrollToCategory(index);
                      },
                      categoriesHeights: childCategoriesHeights,
                      singleTabContent: MarketProductsGridView(products: widget.children[i].products),
                      pageTopOffset: 0,
                    ),
                  ),
          ),
        )
      ],
    );
  }
}

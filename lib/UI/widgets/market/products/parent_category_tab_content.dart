import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_vertical_content.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_products_grid_view.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

import '../../UI/scrollable_horizontal_tabs.dart';

class ParentCategoryTabContent extends StatefulWidget {
  final List<Category> childCategories;
  final int selectedParentCategoryId;

  ParentCategoryTabContent({
    @required this.childCategories,
    @required this.selectedParentCategoryId,
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
  List<Category> selectedParentChildCategories = <Category>[];

  double productGridItemHeight = 0;

  Future<void> _refreshSelectedParentCategory(ProductsProvider productsProvider) async {
    setState(() => _isRefreshingData = true);
    await productsProvider.fetchAndSetChildCategoriesAndProducts(widget.selectedParentCategoryId);
    selectedParentChildCategories = productsProvider.selectedParentChildCategories;
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
    selectedParentChildCategories = widget.childCategories;
    selectedChildCategoryIdNotifier.value = selectedParentChildCategories[0].id;
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
      childCategoriesHeights = List.generate(selectedParentChildCategories.length, (i) {
        int rowsCount = (selectedParentChildCategories[i].products.length / 3).ceil();
        return {
          'id': selectedParentChildCategories[i].id,
          'height': (rowsCount * productGridItemHeight) + (10 * 2) + (10 * (rowsCount - 1)),
        };
      });
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
            children: selectedParentChildCategories,
            itemScrollController: childCategoriesScrollController,
            selectedChildCategoryId: _selectedChildCategoryId,
            //Fired when a child category is clicked
            action: (index) {
              selectedChildCategoryIdNotifier.value = selectedParentChildCategories[index].id;
              scrollToCategory(index);
              scrollToProducts(index);
            },
          ),
        ),
        Consumer<ProductsProvider>(
          builder: (c, productsProvider, _) => Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshSelectedParentCategory(productsProvider),
              child: _isRefreshingData
                  ? Center(child: AppLoader())
                  : ListView.builder(
                      controller: productsScrollController,
                      itemCount: selectedParentChildCategories.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (c, i) => ScrollableVerticalContent(
                        index: i,
                        count: selectedParentChildCategories.length,
                        child: selectedParentChildCategories[i],
                        scrollController: productsScrollController,
                        //Fired when a child category is scrolled into view
                        scrollSpyAction: (index) {
                          selectedChildCategoryIdNotifier.value = selectedParentChildCategories[index].id;
                          scrollToCategory(index);
                        },
                        categoriesHeights: childCategoriesHeights,
                        singleTabContent: MarketProductsGridView(products: selectedParentChildCategories[i].products),
                        pageTopOffset: 0,
                      ),
                    ),
            ),
          ),
        )
      ],
    );
  }
}

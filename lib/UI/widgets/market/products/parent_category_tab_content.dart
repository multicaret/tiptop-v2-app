import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_vertical_content.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_products_grid_view.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

import '../../UI/scrollable_horizontal_tabs.dart';
import 'market_products_shimmer_grid.dart';

class ParentCategoryTabContent extends StatefulWidget {
  final int selectedParentCategoryId;
  final int selectedChildCategoryId;
  final String selectedParentCategoryEnglishTitle;

  ParentCategoryTabContent({
    @required this.selectedParentCategoryId,
    @required this.selectedChildCategoryId,
    @required this.selectedParentCategoryEnglishTitle,
  });

  @override
  _ParentCategoryTabContentState createState() => _ParentCategoryTabContentState();
}

class _ParentCategoryTabContentState extends State<ParentCategoryTabContent> with AutomaticKeepAliveClientMixin {
  bool _isInit = true;
  final selectedChildCategoryIdNotifier = ValueNotifier<int>(null);

  AutoScrollController childCategoriesScrollController;
  AutoScrollController productsScrollController;
  ProductsProvider productsProvider;

  bool scrollIsAtTheTop = true;
  bool _isLoadingParentCategoryData = false;
  List<Map<String, dynamic>> childCategoriesHeights;
  List<Category> selectedParentChildCategories = <Category>[];

  double productGridItemHeight = 0;

  Future<void> _fetchSelectedParentCategoryData() async {
    setState(() => _isLoadingParentCategoryData = true);
    await productsProvider.fetchAndSetChildCategoriesAndProducts(widget.selectedParentCategoryId);
    selectedParentChildCategories = productsProvider.parentCategoryData[widget.selectedParentCategoryId];
    setState(() => _isLoadingParentCategoryData = false);
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

  EventTracking eventTracking = EventTracking.getActions();

  Future<void> trackViewCategoryEvent(String categoryEnglishTitle) async {
    Map<String, String> eventParams = {
      'category_type': 'market',
      'category': categoryEnglishTitle,
      'parent_category': widget.selectedParentCategoryEnglishTitle,
    };
    await eventTracking.trackEvent(TrackingEvent.VIEW_CATEGORY, eventParams);
  }

  void _layoutAndChildCategoriesSetUp() {
    productGridItemHeight = getProductGridItemHeight(context);
    childCategoriesHeights = List.generate(selectedParentChildCategories.length, (i) {
      int rowsCount = (selectedParentChildCategories[i].products.length / 3).ceil();
      return {
        'id': selectedParentChildCategories[i].id,
        'height': (rowsCount * productGridItemHeight) + (10 * 2) + (10 * (rowsCount - 1)),
      };
    });
    if (widget.selectedChildCategoryId != null) {
      selectedChildCategoryIdNotifier.value = widget.selectedChildCategoryId;
      int selectedChildCategoryIndex =
          selectedParentChildCategories.indexWhere((childCategory) => childCategory.id == widget.selectedChildCategoryId);
      scrollToProducts(selectedChildCategoryIndex);
    } else {
      selectedChildCategoryIdNotifier.value = selectedParentChildCategories[0].id;
    }
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
    //Todo: ask if this should be not, not recommended for performance
    // trackViewCategoryEvent(selectedParentChildCategories[0].englishTitle);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productsProvider = Provider.of<ProductsProvider>(context);
      if (productsProvider.parentCategoryData[widget.selectedParentCategoryId] == null) {
        _fetchSelectedParentCategoryData().then((_) {
          _layoutAndChildCategoriesSetUp();
        });
      } else {
        selectedParentChildCategories = productsProvider.parentCategoryData[widget.selectedParentCategoryId];
        _layoutAndChildCategoriesSetUp();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('disposing products page controllers');
    childCategoriesScrollController.dispose();
    productsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedChildCategoryIdNotifier,
          builder: (c, _selectedChildCategoryId, _) => ScrollableHorizontalTabs(
            children: selectedParentChildCategories,
            itemScrollController: childCategoriesScrollController,
            selectedChildCategoryId: _selectedChildCategoryId,
            //Fired when a child category is clicked
            action: (index, categoryEnglishTitle) {
              selectedChildCategoryIdNotifier.value = selectedParentChildCategories[index].id;
              scrollToCategory(index);
              scrollToProducts(index);
              trackViewCategoryEvent(categoryEnglishTitle);
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchSelectedParentCategoryData,
            child: _isLoadingParentCategoryData
                ? MarketProductsShimmerGrid()
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
                      singleTabContent: MarketProductsGridView(
                        products: selectedParentChildCategories[i].products,
                        categoryEnglishTitle: selectedParentChildCategories[i].englishTitle,
                        parentCategoryEnglishTitle: widget.selectedParentCategoryEnglishTitle,
                      ),
                      pageTopOffset: 0,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

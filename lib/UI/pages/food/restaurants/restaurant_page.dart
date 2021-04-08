import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_horizontal_tabs.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_vertical_content.dart';
import 'package:tiptop_v2/UI/widgets/food/products/food_product_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_header_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_search_field.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import '../../../../dummy_data.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/restaurant';

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  AutoScrollController categoriesScrollController;
  AutoScrollController productsScrollController;

  final selectedCategoryIdNotifier = ValueNotifier<int>(null);
  List<Map<String, dynamic>> categoriesHeights;

  final _collapsedNotifier = ValueNotifier<bool>(false);

  void scrollListener() {
    if (productsScrollController.hasClients) {
      if (productsScrollController.offset >= (restaurantPageExpandedHeaderHeight - restaurantPageCollapsedHeaderHeight)) {
        _collapsedNotifier.value = true;
      } else if (productsScrollController.offset < (restaurantPageExpandedHeaderHeight - restaurantPageCollapsedHeaderHeight)) {
        _collapsedNotifier.value = false;
      }
    }
  }

  @override
  void initState() {
    categoriesScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    productsScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
    productsScrollController.addListener(scrollListener);

    selectedCategoryIdNotifier.value = dummyFoodCategories[0].id;

    categoriesHeights = List.generate(
        dummyFoodCategories.length,
        (i) => {
              'id': dummyFoodCategories[i].id,
              'height': foodProductListItemHeight * dummyFoodCategories[i].products.length,
            });
    super.initState();
  }

  @override
  void dispose() {
    productsScrollController.removeListener(scrollListener);
    productsScrollController.dispose();
    super.dispose();
  }

  void scrollToCategory(int index) {
    categoriesScrollController.scrollToIndex(
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
  Widget build(BuildContext context) {
    Restaurant restaurant = ModalRoute.of(context).settings.arguments as Restaurant;
    return AppScaffold(
      hasCurve: false,
      body: CustomScrollView(
        controller: productsScrollController,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            stretch: true,
            onStretchTrigger: () async {
              print('Pulled down!');
            },
            expandedHeight: restaurantPageExpandedHeaderHeight,
            collapsedHeight: restaurantPageCollapsedHeaderHeight,
            backgroundColor: AppColors.bg,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: ValueListenableBuilder(
                valueListenable: _collapsedNotifier,
                builder: (_, _isCollapsed, __) => Transform.translate(
                  offset: Offset(0, _isCollapsed ? -1 : 0),
                  child: Column(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isCollapsed ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !_isCollapsed,
                          child: ValueListenableBuilder(
                            valueListenable: selectedCategoryIdNotifier,
                            builder: (c, _selectedChildCategoryId, _) => ScrollableHorizontalTabs(
                              isInverted: true,
                              children: dummyFoodCategories,
                              itemScrollController: categoriesScrollController,
                              selectedChildCategoryId: _selectedChildCategoryId,
                              //Fired when a child category is clicked
                              action: (i) {
                                selectedCategoryIdNotifier.value = dummyFoodCategories[i].id;
                                scrollToCategory(i);
                                scrollToProducts(i);
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
                        decoration: BoxDecoration(
                          border: _isCollapsed ? Border(bottom: BorderSide(color: AppColors.border)) : null,
                          color: AppColors.bg,
                        ),
                        child: RestaurantSearchField(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
              ],
              centerTitle: true,
              titlePadding: const EdgeInsets.all(0),
              background: RestaurantHeaderInfo(restaurant: restaurant),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                dummyFoodCategories.length,
                (i) {
                  return ScrollableVerticalContent(
                    child: dummyFoodCategories[i],
                    index: i,
                    count: dummyFoodCategories.length,
                    scrollController: productsScrollController,
                    scrollSpyAction: (i) {
                      selectedCategoryIdNotifier.value = dummyFoodCategories[i].id;
                      scrollToCategory(i);
                    },
                    firstItemHasTitle: true,
                    categoriesHeights: categoriesHeights,
                    singleTabContent: Column(
                      children: List.generate(
                        dummyFoodCategories[i].products.length,
                        (j) => FoodProductListItem(product: dummyFoodCategories[i].products[j]),
                      ),
                    ),
                    pageTopOffset: restaurantPageExpandedHeaderHeight,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_horizontal_tabs.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_vertical_content.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_header_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_search_field.dart';
import 'package:tiptop_v2/models/models.dart';
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

  static double categoriesBarHeight = 50;
  static double searchBarHeight = 70;
  double headerExpandedHeight = 460.0;
  double headerCollapsedHeight = categoriesBarHeight + searchBarHeight;
  double productItemHeight = 120;

  void scrollListener() {
    if (productsScrollController.hasClients) {
      if (productsScrollController.offset >= (headerExpandedHeight - headerCollapsedHeight - 10)) {
        _collapsedNotifier.value = true;
      } else if (productsScrollController.offset < (headerExpandedHeight - headerCollapsedHeight - 10)) {
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

    selectedCategoryIdNotifier.value = dummyCategories[0].id;

    categoriesHeights = List.generate(
        dummyCategories.length,
        (i) => {
              'id': dummyCategories[i].id,
              'height': productItemHeight * dummyCategories[i].products.length,
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
            expandedHeight: headerExpandedHeight,
            collapsedHeight: headerCollapsedHeight,
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
                        duration: Duration(milliseconds: 200),
                        opacity: _isCollapsed ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !_isCollapsed,
                          child: Container(
                            height: categoriesBarHeight,
                            color: AppColors.primary,
                            child: ValueListenableBuilder(
                              valueListenable: selectedCategoryIdNotifier,
                              builder: (c, _selectedChildCategoryId, _) => ScrollableHorizontalTabs(
                                isInverted: true,
                                children: dummyCategories,
                                itemScrollController: categoriesScrollController,
                                selectedChildCategoryId: _selectedChildCategoryId,
                                //Fired when a child category is clicked
                                action: (i) {
                                  selectedCategoryIdNotifier.value = dummyCategories[i].id;
                                  // productsScrollController.removeListener(scrollSpyListener);
                                  scrollToCategory(i);
                                  scrollToProducts(i);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
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
              titlePadding: EdgeInsets.all(0),
              background: RestaurantHeaderInfo(restaurant: restaurant),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                dummyCategories.length,
                (i) {
                  return ScrollableVerticalContent(
                    child: dummyCategories[i],
                    index: i,
                    count: dummyCategories.length,
                    scrollController: productsScrollController,
                    scrollSpyAction: (i) {
                      selectedCategoryIdNotifier.value = dummyCategories[i].id;
                      // scrollToCategory(i);
                    },
                    firstItemHasTitle: true,
                    categoriesHeights: categoriesHeights,
                    singleTabContent: Column(
                      children: List.generate(
                        dummyCategories[i].products.length,
                        (j) => Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.secondaryDark, width: 3)),
                          ),
                          child: Center(
                            child: Text(dummyCategories[i].products[j].title),
                          ),
                        ),
                      ),
                    ),
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

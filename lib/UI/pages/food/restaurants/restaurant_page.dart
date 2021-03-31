import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_header_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_search_field.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/restaurant';

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  ScrollController _scrollController;
  final _collapsedNotifier = ValueNotifier<bool>(false);

  static double categoriesBarHeight = 50;
  static double searchBarHeight = 70;
  double headerExpandedHeight = 460.0;
  double headerCollapsedHeight = categoriesBarHeight + searchBarHeight;

  void scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset >= (headerExpandedHeight - headerCollapsedHeight - 10)) {
        _collapsedNotifier.value = true;
      } else if (_scrollController.offset < (headerExpandedHeight - headerCollapsedHeight - 10)) {
        _collapsedNotifier.value = false;
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     Restaurant restaurant = ModalRoute.of(context).settings.arguments as Restaurant;
    return AppScaffold(
      hasCurve: false,
      body: CustomScrollView(
        controller: _scrollController,
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
              child: Transform.translate(
                offset: Offset(0, -1),
                child: ValueListenableBuilder(
                  valueListenable: _collapsedNotifier,
                  builder: (_, _isCollapsed, __) => Column(
                    children: [
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _isCollapsed ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !_isCollapsed,
                          child: Container(
                            height: categoriesBarHeight,
                            color: AppColors.primary,
                            child: ElevatedButton(onPressed: () => print('foo'), child: Text('click me')),
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
              [
                Container(
                  height: 300,
                  color: Colors.red,
                  child: Center(
                    child: Text('Foo'),
                  ),
                ),
                Container(
                  height: 300,
                  color: Colors.blue,
                  child: Center(
                    child: Text('Foo'),
                  ),
                ),
                Container(
                  height: 300,
                  color: Colors.green,
                  child: Center(
                    child: Text('Foo'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

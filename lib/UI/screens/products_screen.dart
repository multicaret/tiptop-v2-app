import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/child_categories_tabs.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

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
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  int selectedParentIndex;

  TabController tabController;
  int _currentTabIndex = 0;

  double _parentsTabHeight = 50.0;
  double _selectedParentTabHeight = 46.0;

  @override
  void initState() {
    selectedParentIndex = widget.parents.indexWhere((parent) => parent.id == widget.selectedParentCategoryId);

    tabController = TabController(length: widget.parents.length, vsync: this);
    tabController.animateTo(selectedParentIndex);
    tabController.animation
      ..addListener(() {
        setState(() {
          _currentTabIndex = (tabController.animation.value).round();
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: _parentsTabHeight,
            color: AppColors.primary,
            child: TabBar(
              isScrollable: true,
              controller: tabController,
              indicator: UnderlineTabIndicator(
                // borderSide: BorderSide(width: 42, color: AppColors.white),
                borderSide: BorderSide(width: 0),
              ),
              indicatorColor: AppColors.white,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                ...widget.parents.asMap().entries.map((entry) {
                  int index = entry.key;
                  Category parent = entry.value;

                  return Tab(
                    child: Transform.translate(
                      offset: Offset(0.0, _parentsTabHeight - _selectedParentTabHeight),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: _currentTabIndex == index ? 15 : 0),
                        margin: EdgeInsets.only(top: _currentTabIndex == index ? _parentsTabHeight - _selectedParentTabHeight : 0),
                        decoration: BoxDecoration(
                          color: _currentTabIndex == index ? AppColors.white : AppColors.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          parent.title,
                          style: _currentTabIndex == index ? AppTextStyles.subtitle : AppTextStyles.subtitleWhite,
                        ),
                      ),
                    ),
                  );
                })
              ],
            )),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: _getParentsTabBarContent(),
          ),
        ),
      ],
    );
  }

  List<Widget> _getParentsTabBarContent() {
    return List.generate(widget.parents.length, (i) {
      bool hasChildCategories = widget.parents[i].hasChildren && widget.parents[i].childCategories.length != 0;

      return hasChildCategories
          ? Column(
              children: [
                ChildCategoriesTabs(
                  children: widget.parents[i].childCategories,
                )
              ],
            )
          : Center(
              child: Text('No Sub Categories/Products'),
            );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ProductsScreen extends StatefulWidget {
  final List<Category> parents;

  ProductsScreen({@required this.parents});

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

  int selectedCategoryId;

  Category selectedParent;
  List<Category> selectedParentChildCategories = [];

  TabController tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: widget.parents.length, vsync: this);
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
            height: 50,
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
              indicatorPadding: EdgeInsets.only(top: 10),
              tabs: <Widget>[
                ...widget.parents.asMap().entries.map((entry) {
                  int index = entry.key;
                  Category parent = entry.value;

                  return Tab(
                    child: Transform.translate(
                      offset: const Offset(0.0, 4.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: _currentTabIndex == index ? 10 : 0),
                        // margin: EdgeInsets.only(top: _currentTabIndex == index ? 6 : 0),
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
            children: <Widget>[...widget.parents.map((parent) => Center(child: Text(parent.title)))],
          ),
        )
/*              ParentCategoriesTabs(
                    action: (int parentId) {
                      homeProvider.selectCategory(parentId);
                      setState(() {
                        _localSelectedCategoryId = parentId;
                      });
                    },
                    selectedCategoryId: selectedCategoryId,
                    //Todo: find a better way
                    localSelectedCategoryId: _localSelectedCategoryId,
                    parents: parents,
                  ),*/
/*            if (selectedParent.hasChildren && selectedParentChildCategories != null)
              ChildCategoriesTabs(
                children: selectedParentChildCategories,
              )*/
      ],
    );
  }
}

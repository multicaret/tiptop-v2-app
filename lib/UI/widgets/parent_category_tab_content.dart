import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'child_categories_tabs.dart';

class ParentCategoryTabContent extends StatefulWidget {
  final List<Category> children;

  ParentCategoryTabContent({@required this.children});

  @override
  _ParentCategoryTabContentState createState() => _ParentCategoryTabContentState();
}

class _ParentCategoryTabContentState extends State<ParentCategoryTabContent> {
  int selectedChildCategoryId;

  ItemScrollController childCategoryScrollController;
  ItemPositionsListener childCategoryItemPositionsListener;

  ItemScrollController productsScrollController;
  ItemPositionsListener productsPositionsListener;

  @override
  void initState() {
    childCategoryScrollController = ItemScrollController();
    childCategoryItemPositionsListener = ItemPositionsListener.create();

    productsScrollController = ItemScrollController();
    productsPositionsListener = ItemPositionsListener.create();

    selectedChildCategoryId = widget.children[0].id;
    super.initState();
  }

  void scrollTo(int index) {
    childCategoryScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );

    productsScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildCategoriesTabs(
          children: widget.children,
          itemScrollController: childCategoryScrollController,
          itemPositionsListener: childCategoryItemPositionsListener,
          selectedChildCategoryId: selectedChildCategoryId,
          action: (i) {
            setState(() {
              selectedChildCategoryId = widget.children[i].id;
            });
            scrollTo(i);
          },
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
            itemCount: widget.children.length,
            itemBuilder: (context, i) {
              return childCategoryProducts(
                index: i,
                child: widget.children[i],
              );
            },
            itemScrollController: productsScrollController,
            itemPositionsListener: productsPositionsListener,
          ),
        )
      ],
    );
  }

  Widget childCategoryProducts({Category child, int index}) {
    List<Product> products = child.products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (index != 0)
          Container(
            padding: EdgeInsets.only(right: 17, left: 17, top: 30, bottom: 5),
            color: AppColors.bg,
            child: Text(
              child.title,
              style: AppTextStyles.body50,
            ),
          ),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            ...products.map((product) => Container(
                  height: 200,
                  color: AppColors.secondaryDark,
                  child: Center(child: Text(product.title)),
                ))
          ],
        ),
      ],
    );
  }
}

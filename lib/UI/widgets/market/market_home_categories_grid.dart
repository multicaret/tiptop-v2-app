import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/market/market_products_page.dart';
import 'package:tiptop_v2/UI/widgets/market/category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class MarketHomeCategoriesGrid extends StatelessWidget {
  final List<Category> parentCategories;

  MarketHomeCategoriesGrid({
    @required this.parentCategories,
  });

  @override
  Widget build(BuildContext context) {
    // print('Built market home categories grid!');
    double colSize = getColItemHeight(4, context);
    double crossAxisCount = colSize / (colSize + 25);

    return GridView.count(
      padding: const EdgeInsets.only(right: screenHorizontalPadding, left: screenHorizontalPadding, top: 10, bottom: 20),
      shrinkWrap: true,
      childAspectRatio: crossAxisCount,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 15,
      mainAxisSpacing: 16,
      children: parentCategories
          .map((category) => GestureDetector(
                onTap: () {
                  pushCupertinoPage(
                    context,
                    MarketProductsPage(
                      selectedParentCategoryId: category.id,
                    ),
                  );
                },
                child: CategoryItem(
                  title: category.title,
                  imageUrl: category.thumbnail,
                ),
              ))
          .toList(),
    );
  }
}

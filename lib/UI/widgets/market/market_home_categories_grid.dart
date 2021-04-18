import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/market/market_products_page.dart';
import 'package:tiptop_v2/UI/widgets/market/category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class MarketHomeCategoriesGrid extends StatelessWidget {
  final List<Category> categories;
  final Function fetchAndSetHomeData;

  MarketHomeCategoriesGrid({
    @required this.categories,
    @required this.fetchAndSetHomeData,
  });

  @override
  Widget build(BuildContext context) {
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
      children: categories
          .map((category) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (BuildContext context) => MarketProductsPage(
                        selectedParentCategoryId: category.id,
                        parents: categories,
                        refreshHomeData: fetchAndSetHomeData,
                      ),
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

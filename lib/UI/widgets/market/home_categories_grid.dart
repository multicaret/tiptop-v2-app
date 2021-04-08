import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/market/products_page.dart';
import 'package:tiptop_v2/UI/widgets/market/category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/helper.dart';

class HomeCategoriesGrid extends StatelessWidget {
  final List<Category> categories;
  final Function fetchAndSetHomeData;
  final bool isLoadingHomeData;

  HomeCategoriesGrid({
    @required this.categories,
    @required this.fetchAndSetHomeData,
    @required this.isLoadingHomeData,
  });

  @override
  Widget build(BuildContext context) {
    double colSize = getColItemHeight(4, context);
    double crossAxisCount = colSize / (colSize + 25);

    return GridView.count(
      padding: const EdgeInsets.only(right: 17, left: 17, top: 10, bottom: 20),
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
                      builder: (BuildContext context) => ProductsPage(
                        selectedParentCategoryId: category.id,
                        parents: categories,
                        refreshHomeData: fetchAndSetHomeData,
                        isLoadingHomeData: isLoadingHomeData,
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

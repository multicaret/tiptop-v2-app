import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/profile/article_page.dart';
import 'package:tiptop_v2/models/blog.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'UI/app_cached_network_image.dart';

class ArticleListItem extends StatelessWidget {
  final Article article;

  ArticleListItem({
    this.article,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(ArticlePage.routeName, arguments: {'article_id': article.id}),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    // leading: Icon(Icons.arrow_drop_down_circle),
                    title: Text(
                      article.title,
                      style: AppTextStyles.body,
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.calendarAlt,
                          size: 14.0,
                          color: AppColors.text50,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          article.updatedAt.formatted,
                          style: AppTextStyles.subtitle50,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(screenHorizontalPadding),
                    child: Text(
                      article.exc.raw,
                      style: AppTextStyles.subtitle,
                    ),
                  ),
                  // if (/*article.cover*/ false) Image.asset('assets/card-sample-image.jpg'),
                ],
              ),
            ),
            Expanded(
              child: Consumer<AppProvider>(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [const BoxShadow(blurRadius: 4, color: AppColors.shadow)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: AppCachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: article.cover,
                      loaderWidget: SpinKitDoubleBounce(color: AppColors.secondary),
                    ),
                  ),
                ),
                builder: (c, appProvider, child) => Padding(
                  padding: appProvider.isRTL ? EdgeInsets.only(left: screenHorizontalPadding) : EdgeInsets.only(right: screenHorizontalPadding),
                  child: child,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

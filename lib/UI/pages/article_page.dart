import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/models/blog.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ArticlePage extends StatefulWidget {
  static const routeName = '/article';
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Article article;
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    article = data['article'];

    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: AssetImage('assets/images/slide-2.png'),
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.calendarAlt,
                  size: 14.0,
                  color: AppColors.text50,
                ),
                SizedBox(width: 5.0),
                Text(
                  article.updatedAt.formatted,
                  style: AppTextStyles.body50,
                ),
              ],
            ),
            Html(
              data: """${article.content.formatted}""",
            )
          ],
        ),
      ),
    );
  }
}

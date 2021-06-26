import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cahched_network_image.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/models/blog.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ArticlePage extends StatefulWidget {
  static const routeName = '/article';

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Article article;
  bool _isLoading = false;
  bool _isInit = true;
  int articleId;

  Future<void> _fetchAndSetContent() async {
    setState(() {
      _isLoading = true;
    });
    final responseData = await AppProvider().get(endpoint: 'blog/$articleId');
    article = Article.fromJson(responseData["data"]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      articleId = data["article_id"];
      _fetchAndSetContent();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      appBar: _isLoading ? null : AppBar(title: Text(article.title)),
      body: _isLoading
          ? AppLoader()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10.0),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [const BoxShadow(blurRadius: 5, color: AppColors.shadow)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: AppCachedNetworkImage(
                        imageUrl: article.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
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
                  Html(data: """${article.content.formatted}""")
                ],
              ),
            ),
    );
  }
}

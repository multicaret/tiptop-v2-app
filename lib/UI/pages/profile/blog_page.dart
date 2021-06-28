import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/article_list_item.dart';
import 'package:tiptop_v2/models/blog.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class BlogPage extends StatefulWidget {
  static const routeName = '/blog';

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  bool _isLoading = false;
  List<Article> _articles = [];

  @override
  void initState() {
    _fetchAndSetContent();
    super.initState();
  }

  Future<void> _fetchAndSetContent() async {
    setState(() {
      _isLoading = true;
    });
    final responseData = await AppProvider().get(endpoint: 'blog');
    _articles = List<Article>.from(responseData["data"].map((x) => Article.fromJson(x)));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      body: Container(
        color: AppColors.bg,
        padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 20.0),
        child: RefreshIndicator(
          onRefresh: _fetchAndSetContent,
          child: _isLoading
              ? const Center(child: const AppLoader())
              : ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (context, i) => ArticleListItem(article: _articles[i]),
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/models/blog.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

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
    BlogResponse staticPageResponse = BlogResponse.fromJson(responseData);
    _articles = staticPageResponse.articles;
    print("_articles");
    print(_articles.length);
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
        padding: EdgeInsets.only(left: 17.0, right: 17.0, top: 20.0),
        child: RefreshIndicator(
          onRefresh: _fetchAndSetContent,
          child: _isLoading
              ? Center(child: AppLoader())
              : ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (context, i) => ArticleTile(article: _articles[i]),
                ),
        ),
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final Article article;

  ArticleTile({this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
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
                SizedBox(width: 5.0),
                Text(
                  article.updatedAt.formatted,
                  style: AppTextStyles.subtitle50,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: Text(
              article.exc.raw,
              style: AppTextStyles.subtitle,
            ),
          ),
          if (/*article.cover*/ false) Image.asset('assets/card-sample-image.jpg'),
        ],
      ),
    );
  }
}

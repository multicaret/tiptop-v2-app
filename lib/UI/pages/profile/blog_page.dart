import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/profile/article_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/models/blog.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
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
                  itemBuilder: (context, i) => ArticleTile(article: _articles[i]),
                ),
        ),
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final Article article;
  final AppProvider appProvider;

  ArticleTile({
    this.article,
    this.appProvider,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(ArticlePage.routeName, arguments: {'article': article}),
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
                    padding: const EdgeInsets.all(screenHorizontalPadding,),
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
              child: Padding(
                padding: appProvider.isRTL ? EdgeInsets.only(left: screenHorizontalPadding) : EdgeInsets.only(right: screenHorizontalPadding,),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [const BoxShadow(blurRadius: 4, color: AppColors.shadow)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: article.cover,
                      placeholder: (_, __) => SpinKitDoubleBounce(color: AppColors.secondary),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

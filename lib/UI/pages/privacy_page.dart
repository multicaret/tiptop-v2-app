import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/models/static_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';

class PrivacyPage extends StatefulWidget {
  static const routeName = '/privacy';

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool _isLoading = false;
  StaticPage _privacy;

  @override
  void initState() {
    _fetchAndSetContent();
    super.initState();
  }

  Future<void> _fetchAndSetContent() async {
    setState(() {
      _isLoading = true;
    });
    final responseData = await AppProvider().get(endpoint: 'privacy-policy');
    StaticPageResponse staticPageResponse = StaticPageResponse.fromJson(responseData);
    _privacy = staticPageResponse.staticPage;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: RefreshIndicator(
        onRefresh: _fetchAndSetContent,
        child: _isLoading
            ? Center(child: AppLoader())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                child: Html(
                  shrinkWrap: true,
                  data: """${_privacy.content.formatted}""",
                ),
              ),
      ),
    );
  }
}

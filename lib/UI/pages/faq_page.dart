import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/expansion_tile.dart';
import 'package:tiptop_v2/models/faq.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class FaqPage extends StatefulWidget {
  static const routeName = '/faq';

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool _isLoading = false;
  List<FaqItem> _faqs = [];

  @override
  void initState() {
    _fetchAndSetContent();
    super.initState();
  }

  Future<void> _fetchAndSetContent() async {
    setState(() {
      _isLoading = true;
    });
    final responseData = await AppProvider().get(endpoint: 'faq');
    FaqResponse staticPageResponse = FaqResponse.fromJson(responseData);
    _faqs = staticPageResponse.data;
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
        child: RefreshIndicator(
          onRefresh: _fetchAndSetContent,
          child: _isLoading
              ? Center(child: AppLoader())
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  // padding: EdgeInsets.symmetric(horizontal: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        _faqs.length,
                        (i) => CustomExpansionTile(
                              title: _faqs[i].question,
                              content: _faqs[i].answer.formatted,
                            )),
                  ),
                ),
        ),
      ),
    );
  }
}

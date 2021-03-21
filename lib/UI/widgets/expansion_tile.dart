import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String content;

  CustomExpansionTile({
    @required this.title,
    @required this.content,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  AnimationController _rotationController;

  @override
  void initState() {
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: AppColors.primary50.withOpacity(0.6),
          )),
          color: AppColors.white
          // borderRadius: BorderRadius.circular(25),
          ),
      child: Theme(
        data: theme,
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: Text(
              widget.title,
              style: AppTextStyles.bodyBold,
            ),
          ),
          trailing: RotationTransition(
            turns: Tween(begin: 0.0, end: 0.5).animate(_rotationController),
            child: AppIcon.iconPrimary(FontAwesomeIcons.angleDown),
          ),
          onExpansionChanged: (value) {
            value ? _rotationController.forward() : _rotationController.reverse();
          },
          children: <Widget>[
            Container(
              color: AppColors.bg,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 5.0),
                child: Html(data: """${widget.content}"""),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

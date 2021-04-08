import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ScrollableVerticalContent extends StatefulWidget {
  final Category child;
  final int index;
  final int count;
  final AutoScrollController scrollController;
  final Function scrollSpyAction;
  final List<Map<String, dynamic>> categoriesHeights;
  final Widget singleTabContent;
  final bool firstItemHasTitle;
  final double pageTopOffset;

  ScrollableVerticalContent({
    @required this.child,
    @required this.index,
    @required this.count,
    @required this.scrollController,
    @required this.scrollSpyAction,
    @required this.categoriesHeights,
    @required this.singleTabContent,
    this.firstItemHasTitle = false,
    @required this.pageTopOffset,
  });

  @override
  _ScrollableVerticalContentState createState() => _ScrollableVerticalContentState();
}

class _ScrollableVerticalContentState extends State<ScrollableVerticalContent> {
  GlobalKey key = GlobalKey();
  double categoryPosition = 0;
  double currentCategoryHeight;
  double previousCategoriesHeights = 0;

  void scrollSpyListener() {
    double scrollPosition = widget.scrollController.position.pixels;
    if (widget.scrollController.hasClients) {
      if (scrollPosition <= 0) {
        widget.scrollSpyAction(0);
      } else {
        if (scrollPosition >= previousCategoriesHeights + widget.pageTopOffset &&
            scrollPosition < previousCategoriesHeights + widget.pageTopOffset + 10) {
          widget.scrollSpyAction(widget.index);
        } else if (scrollPosition == widget.scrollController.position.maxScrollExtent) {
          widget.scrollSpyAction(widget.count - 1);
        }
      }
    }
  }

  @override
  void initState() {
    widget.scrollController.addListener(scrollSpyListener);
    currentCategoryHeight = widget.categoriesHeights[widget.index]['height'];
    if (widget.index > 0) {
      for (int i = widget.index - 1; i >= 0; i--) {
        previousCategoriesHeights += widget.categoriesHeights[i]['height'];
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollSpyListener);
    super.dispose();
  }

  int count = 1;

  @override
  Widget build(BuildContext context) {
    print('Built ${widget.child.title} widget ${count++} times!!!');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.index != 0 || widget.firstItemHasTitle)
          Container(
            padding: const EdgeInsets.only(right: 17, left: 17, top: 30, bottom: 5),
            color: AppColors.bg,
            child: Text(
              widget.child.title,
              style: AppTextStyles.body50,
            ),
          ),
        Container(
          color: AppColors.white,
          height: widget.categoriesHeights[widget.index]['height'],
          child: AutoScrollTag(
            controller: widget.scrollController,
            index: widget.index,
            key: ValueKey(widget.index),
            child: widget.singleTabContent,
          ),
        ),
      ],
    );
  }
}

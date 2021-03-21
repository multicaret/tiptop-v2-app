import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'app_carousel.dart';
import 'app_scaffold.dart';
import 'formatted_price.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage({@required this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ScrollController _controller;
  bool popFlag = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent - 100 && popFlag == false) {
      popFlag = true;
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    AppProvider appProvider = Provider.of<AppProvider>(context);
    List<String> productGallery = [widget.product.media.cover, ...widget.product.media.gallery.map((galleryItem) => galleryItem.file)];

    return AppScaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.clear : CupertinoIcons.clear_thick),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        children: [
          AppCarousel(
            height: 400,
            // images: carouselImages,
            hasDots: productGallery.length > 1,
            images: productGallery,
          ),
          SizedBox(height: 20),
          Text(
            widget.product.title,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          if (widget.product.discountedPrice != null)
            FormattedPrice(
              price: widget.product.discountedPrice.amountFormatted,
              isLarge: true,
            ),
          FormattedPrice(
            price: widget.product.price.amountFormatted,
            isDiscounted: widget.product.discountedPrice != null,
            isLarge: true,
          ),
          if (widget.product.unitText != null) Text(widget.product.unitText, style: AppTextStyles.subtitleXs50),
          SizedBox(height: 20),
          if (widget.product.description != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(right: 17, left: 17, top: 30, bottom: 5),
              color: AppColors.bg,
              child: Text(
                'Details',
                style: AppTextStyles.body50,
              ),
            ),
          if (widget.product.description != null)
            Container(
              child: Html(
                data: """${widget.product.description.formatted}""",
              ),
            ),
/*          Container(
            color: Colors.red,
            height: 500,
          ),*/
        ],
      ),
    );

/*    return Draggable(
      child: Container(
        height: screenSize.height - 95,
        decoration: BoxDecoration(
          color: AppColors.secondaryDark,
          image: DecorationImage(
            image: AssetImage('assets/images/appbar-bg-pattern.png'),
            alignment: Alignment.topCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 140),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      alignment: appProvider.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                      icon: Icon(Platform.isAndroid ? Icons.clear : CupertinoIcons.clear_thick),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      product.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h2,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              Container(
                color: AppColors.white,
                child: Container(
                  color: Colors.red,
                  height: 3000,
                  child: Center(
                    child: Text('foo'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );*/
  }
}

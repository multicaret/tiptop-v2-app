import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'app_carousel.dart';
import 'app_scaffold.dart';
import 'formatted_price.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage({
    @required this.product,
  });

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
    List<String> productGallery = [widget.product.media.cover, ...widget.product.media.gallery.map((galleryItem) => galleryItem.file)];

    return AppScaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.clear : CupertinoIcons.clear_thick),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _controller,
              children: [
                AppCarousel(
                  height: 400,
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
                    padding: EdgeInsets.symmetric(horizontal: 9),
                    child: Html(
                      data: """${widget.product.description.formatted}""",
                    ),
                  ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 105,
            child: Container(
              padding: EdgeInsets.only(top: 20, bottom: 40, right: 17, left: 17),
              height: 45,
              color: AppColors.bg,
              child: CartControls(
                isModalControls: true,
                product: widget.product,
                cartButtonHeight: 45,
              ),
            ),
          )
        ],
      ),
    );
  }
}

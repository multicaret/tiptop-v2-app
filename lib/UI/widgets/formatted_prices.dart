import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/models.dart';

import 'UI/formatted_price.dart';

class FormattedPrices extends StatelessWidget {
  final bool isRow;
  final DoubleRawIntFormatted price;
  final DoubleRawIntFormatted discountedPrice;
  final bool isLarge;

  FormattedPrices({
    this.isRow = false,
    this.price,
    this.discountedPrice,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    bool hasDiscountedPrice = discountedPrice != null && discountedPrice.raw != 0;
    return isRow ? Row(children: _formattedPricesList(hasDiscountedPrice)) : Column(children: _formattedPricesList(hasDiscountedPrice));
  }

  List<Widget> _formattedPricesList(bool hasDiscountedPrice) {
    return List.generate(hasDiscountedPrice ? 2 : 1, (i) {
      return FormattedPrice(
        isLarge: isLarge,
        price: hasDiscountedPrice && i == 0 ? discountedPrice.formatted : price.formatted,
        isDiscounted: i != 0 && hasDiscountedPrice,
      );
    });
  }
}

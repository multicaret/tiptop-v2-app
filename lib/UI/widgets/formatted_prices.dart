import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/models.dart';

import 'UI/formatted_price.dart';

class FormattedPrices extends StatelessWidget {
  final DoubleRawIntFormatted price;
  final DoubleRawIntFormatted discountedPrice;
  final bool isLarge;
  final bool isEndAligned;

  FormattedPrices({
    this.price,
    this.discountedPrice,
    this.isLarge = false,
    this.isEndAligned = false,
  });

  @override
  Widget build(BuildContext context) {
    bool hasDiscountedPrice = discountedPrice != null && discountedPrice.raw != 0 && discountedPrice.raw < price.raw;
    return Column(children: _formattedPricesList(hasDiscountedPrice));
  }

  List<Widget> _formattedPricesList(bool hasDiscountedPrice) {
    return List.generate(
      hasDiscountedPrice ? 2 : 1,
      (i) => FormattedPrice(
        isLarge: isLarge,
        isEndAligned: isEndAligned,
        price: hasDiscountedPrice && i == 0 ? discountedPrice.formatted : price.formatted,
        isDiscounted: i != 0 && hasDiscountedPrice,
      ),
    );
  }
}

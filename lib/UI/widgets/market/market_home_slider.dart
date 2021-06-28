import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_carousel.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';

import '../map_slide.dart';

class MarketHomeSlider extends StatelessWidget {
  final List<Slide> slides;
  final BranchDelivery delivery;

  MarketHomeSlider({
    @required this.slides,
    @required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    return AppCarousel(
      images: slides.map((slide) => slide.image).toList(),
      infinite: slides.length > 0,
      autoPlay: slides.length > 0,
      autoplayDuration: const Duration(milliseconds: 300),
      autoPlayInterval: const Duration(seconds: 7),
      mapWidget: Consumer<AddressesProvider>(
        builder: (c, addressesProvider, _) => MapSlide(
          selectedAddress: addressesProvider.selectedAddress,
          delivery: delivery,
        ),
      ),
    );
  }
}

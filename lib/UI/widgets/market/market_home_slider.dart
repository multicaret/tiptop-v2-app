import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_carousel.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/models/home.dart';

import '../map_slide.dart';

class MarketHomeSlider extends StatelessWidget {
  final List<Slide> slides;
  final BranchDelivery delivery;
  final Address selectedAddress;

  MarketHomeSlider({
    @required this.slides,
    @required this.delivery,
    @required this.selectedAddress,
  });

  @override
  Widget build(BuildContext context) {
    return AppCarousel(
      images: slides.map((slide) => slide.image).toList(),
      infinite: slides.length > 0,
      autoPlay: slides.length > 0,
      autoplayDuration: const Duration(milliseconds: 300),
      autoPlayInterval: const Duration(seconds: 7),
      mapWidget: MapSlide(
        selectedAddress: selectedAddress,
        delivery: delivery,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_carousel.dart';
import 'package:tiptop_v2/models/home.dart';

class FoodHomeSlider extends StatelessWidget {
  final List<Slide> slides;

  FoodHomeSlider({@required this.slides});

  @override
  Widget build(BuildContext context) {
    return AppCarousel(
      images: slides.map((slide) => slide.image).toList(),
      links: slides.map((slide) => {
        'type': slide.linkType,
        'value': slide.linkValue,
      }).toList(),
      infinite: slides.length > 1,
      autoPlay: slides.length > 1,
      autoplayDuration: const Duration(milliseconds: 300),
      autoPlayInterval: const Duration(seconds: 7),
    );
  }
}

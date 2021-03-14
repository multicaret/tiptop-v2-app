import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_carousel.dart';

class CategoriesScreen extends StatelessWidget {
  static List<String> _carouselImages = [
    'assets/images/slide-1.png',
    'assets/images/slide-2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddressSelectButton(),
        AppCarousel(
          images: _carouselImages,
          autoplayDuration: Duration(milliseconds: 3000),
        )
      ],
    );
  }
}

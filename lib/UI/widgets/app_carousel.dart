import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppCarousel extends StatelessWidget {
  final double height;
  final double width;
  final List<String> images;
  final double dotSize;
  final Radius radius;
  final Color dotBgColor;
  final double dotVerticalPadding;
  final bool imageOverlay;
  final bool hasDots;
  final Duration autoplayDuration;

  AppCarousel({
    this.height = 212,
    this.width,
    @required this.images,
    this.dotSize = 5,
    this.radius,
    this.dotBgColor,
    this.dotVerticalPadding = 0,
    this.imageOverlay = false,
    this.hasDots = false,
    this.autoplayDuration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Carousel(
        animationDuration: Duration(milliseconds: 400),
        boxFit: BoxFit.cover,
        dotSize: hasDots ? images.length > 1 ? dotSize : 0 : 0,
        dotIncreaseSize: 1.6,
        dotSpacing: 12,
        dotVerticalPadding: dotVerticalPadding,
        dotColor: AppColors.white.withOpacity(0.5),
        radius: radius,
        overlayShadow: false,
        borderRadius: radius != null,
        autoplay: autoplayDuration != null,
        autoplayDuration: autoplayDuration,
        dotBgColor: hasDots ? dotBgColor : Colors.transparent,
        images: images
            .map((image) => imageOverlay
                ? CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    color: AppColors.text.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                  )
                : CachedNetworkImageProvider(image))
            .toList(),
      ),
    );
  }
}

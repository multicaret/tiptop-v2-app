import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/deeplinks_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_cahched_network_image.dart';

class AppCarousel extends StatelessWidget {
  final double height;
  final double width;
  final List<String> images;
  final bool autoPlay;
  final Duration autoplayDuration;
  final Duration autoPlayInterval;
  final Widget mapWidget;
  final bool infinite;
  final bool hasIndicator;
  final List<Map<String, dynamic>> links;

  AppCarousel({
    this.height = 212,
    this.width,
    @required this.images,
    this.autoPlay = false,
    this.autoplayDuration,
    this.autoPlayInterval,
    this.mapWidget,
    this.infinite = true,
    this.hasIndicator = false,
    this.links,
  });

  final currentSlideNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: CarouselSlider(
            items: mapWidget != null ? [mapWidget, ..._getImagesList(context)] : _getImagesList(context),
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: autoPlay,
              height: height,
              autoPlayInterval: autoPlayInterval,
              autoPlayAnimationDuration: autoplayDuration,
              onPageChanged: (index, reason) => currentSlideNotifier.value = index,
              enableInfiniteScroll: infinite,
            ),
          ),
        ),
        if (hasIndicator && images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ValueListenableBuilder(
              valueListenable: currentSlideNotifier,
              builder: (c, currentSlide, _) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return AnimatedContainer(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    duration: const Duration(milliseconds: 300),
                    height: currentSlide == index ? 10 : 8,
                    width: currentSlide == index ? 10 : 8,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(currentSlide == index ? 1 : 0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _getImagesList(BuildContext context) {
    return List.generate(
      images.length,
      (i) => Consumer2<AppProvider, HomeProvider>(
        child: AppCachedNetworkImage(
          imageUrl: images[i],
          width: double.infinity,
        ),
        builder: (c, appProvider, homeProvider, child) => GestureDetector(
          onTap: links == null || links.length == 0 || links[i] == null
              ? null
              : () {
                  String link = links[i]['value'];
                  print('Slider link: $link');
                  if (links[i]['type'] == LinkType.EXTERNAL && link != null) {
                    launch(links[i]['value']);
                  } else {
                    Uri uri = Uri.parse(link);
                    runDeepLinkAction(context, uri, appProvider.isAuth, homeProvider);
                  }
                },
          child: child,
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCarousel extends StatefulWidget {
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

  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> with AutomaticKeepAliveClientMixin<AppCarousel> {
  final CarouselController _controller = CarouselController();
  final currentSlideNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    if (_controller.ready) {
      _controller.startAutoPlay();
    }
    super.initState();
  }

  @override
  void dispose() {
    print('Disposed carousel!');
    _controller.stopAutoPlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: CarouselSlider(
            carouselController: _controller,
            items: widget.mapWidget != null ? [widget.mapWidget, ..._getImagesList()] : _getImagesList(),
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: widget.autoPlay,
              height: widget.height,
              autoPlayInterval: widget.autoPlayInterval,
              autoPlayAnimationDuration: widget.autoplayDuration,
              onPageChanged: (index, reason) => currentSlideNotifier.value = index,
              enableInfiniteScroll: widget.infinite,
            ),
          ),
        ),
        if (widget.hasIndicator && widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ValueListenableBuilder(
              valueListenable: currentSlideNotifier,
              builder: (c, currentSlide, _) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
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

  List<Widget> _getImagesList() {
    return List.generate(
        widget.images.length,
        (i) => GestureDetector(
              onTap: widget.links == null || widget.links.length == 0 || widget.links[i] == null
                  ? null
                  : () {
                      print('Slider links:');
                      print(widget.links);
                      if (widget.links[i]['type'] == LinkType.EXTERNAL && widget.links[i]['value'] != null) {
                        launch(widget.links[i]['value']);
                      }
                    },
              child: CachedNetworkImage(
                imageUrl: widget.images[i],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) => SpinKitFadingCircle(
                  color: AppColors.secondary,
                ),
              ),
            ));
  }

  @override
  bool get wantKeepAlive => true;
}

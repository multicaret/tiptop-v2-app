import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppCarousel extends StatefulWidget {
  final double height;
  final double width;
  final List<String> images;
  final Duration autoplayDuration;
  final Duration autoPlayInterval;
  final Widget mapWidget;
  final bool infinite;
  final bool hasIndicator;

  AppCarousel({
    this.height = 212,
    this.width,
    @required this.images,
    this.autoplayDuration,
    this.autoPlayInterval,
    this.mapWidget,
    this.infinite = true,
    this.hasIndicator = false,
  });

  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  final CarouselController _controller = CarouselController();
  int _currentSlide = 0;

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
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: CarouselSlider(
            carouselController: _controller,
            //Building widgets on demand (if needed)
            /*itemCount: widget.mapWidget != null ? widget.images.length + 1 : widget.images.length,
            itemBuilder: (c, index, _) {
              return CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.cover,
                      color: AppColors.text.withOpacity(widget.imageOverlay ? 0.3 : 0),
                      colorBlendMode: BlendMode.darken,
                    );
            },*/
            items: _getImagesList(),
            // items: widget.mapWidget != null ? [widget.mapWidget, ..._getImagesList()] : _getImagesList(),
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: widget.autoplayDuration != null && widget.autoPlayInterval != null,
              height: widget.height,
              autoPlayInterval: widget.autoPlayInterval,
              autoPlayAnimationDuration: widget.autoplayDuration,
              onPageChanged: (index, reason) => setState(() => _currentSlide = index),
              enableInfiniteScroll: widget.infinite,
            ),
          ),
        ),
        if (widget.hasIndicator && widget.images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return AnimatedContainer(
                margin: EdgeInsets.symmetric(horizontal: 3),
                duration: const Duration(milliseconds: 300),
                height: _currentSlide == index ? 10 : 8,
                width: _currentSlide == index ? 10 : 8,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _currentSlide == index ? 1 : 0.5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  List<Widget> _getImagesList() {
    return List.generate(
        widget.images.length,
        (i) => CachedNetworkImage(
              imageUrl: widget.images[i],
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) => SpinKitFadingCircle(
                color: AppColors.secondary,
              ),
            ));
  }
}

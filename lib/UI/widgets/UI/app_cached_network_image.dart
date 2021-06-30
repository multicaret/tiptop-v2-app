import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final LoadingErrorWidgetBuilder customErrorWidgetBuilder;
  final Widget customErrorWidget;
  final Widget loaderWidget;
  final double height;
  final double width;
  final BoxFit fit;
  final Alignment alignment;
  final Color color;
  final BlendMode colorBlendMode;

  AppCachedNetworkImage({
    @required this.imageUrl,
    this.customErrorWidgetBuilder,
    this.customErrorWidget,
    this.loaderWidget,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.alignment,
    this.color,
    this.colorBlendMode,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (_, __) =>
          loaderWidget ??
          SpinKitFadingCircle(
            color: AppColors.secondary,
            size: 20,
          ),
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      errorWidget: customErrorWidgetBuilder ??
          (BuildContext context, String url, dynamic error) {
            // print("🖼 🖼 🖼 🖼 🖼 🖼 🖼 🖼 Error Fetching Image 🖼 🖼 🖼 🖼 🖼 🖼 🖼 🖼");
            // print("Image url: $url");
            return customErrorWidget ?? Center(child: Text("-", style: AppTextStyles.subtitleXs50));
          },
    );
  }
}

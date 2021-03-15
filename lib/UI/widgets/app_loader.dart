import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;
  final bool isFitted;

  const AppLoader({
    Key key,
    this.color = AppColors.secondaryDark,
    this.size = 50.0,
    this.isFitted = false,
    this.duration = const Duration(milliseconds: 1400),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFitted
        ? FittedBox(
            fit: BoxFit.fitWidth,
            child: SpinKitFadingFour(
              color: color,
              size: size,
              duration: duration,
            ),
          )
        : SpinKitFadingFour(
            color: color,
            size: size,
            duration: duration,
          );
  }
}
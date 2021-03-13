import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  final EdgeInsetsGeometry bodyPadding;
  final String bgImage;
  final bool automaticallyImplyLeading;
  final ConvexAppBar bottomNavigationBar;

  const AppScaffold({
    this.body,
    this.appBar,
    this.bodyPadding,
    this.bgImage,
    this.automaticallyImplyLeading = true,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: AppColors.white,
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            color: AppColors.secondaryDark,
            child: Image.asset(
              'assets/images/appbar-bg-pattern.png',
              width: screenSize.width,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: appBar ??
              AppBar(
                automaticallyImplyLeading: automaticallyImplyLeading,
                title: Image.asset(
                  'assets/images/tiptop-logo-title.png',
                  width: 77.42,
                  height: 26.84,
                ),
              ),
          body: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              decoration: BoxDecoration(
                color: AppColors.white,
                image: bgImage != null
                    ? DecorationImage(
                        image: AssetImage(bgImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              padding: bodyPadding ?? EdgeInsets.symmetric(horizontal: 17),
              child: body,
            ),
          ),
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }
}

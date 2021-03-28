import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/track_order_map.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class TrackOrderPage extends StatefulWidget {
  static const routeName = '/track-order';

  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  bool _isInit = true;
  HomeProvider homeProvider;
  AppProvider appProvider;

  double sliderValue = 1;
  double leftPosition = 30;
  int sliderDivisions = 3;
  double screenGutter = 17.0;
  double sliderIndicatorWidth = 55.0;
  double sliderIndicatorHeight = 65.0;
  double sliderSideGutter = 20;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      homeProvider = Provider.of<HomeProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  List<String> _stepsText = [
    "Preparing",
    "On the way",
    "At the address",
    "Delivered",
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double infoContainerWidth = screenSize.width - (screenGutter * 2);

    return AppScaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).get("Track your order")),
      ),
      body: Column(
        children: [
          AddressSelectButton(isDisabled: true),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: screenSize.height,
                  child: TrackOrderMap(),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  bottom: 225,
                  left: appProvider.isRTL ? null : getOffset(screenSize.width),
                  right: appProvider.isRTL ? getOffset(screenSize.width) : null,
                  child: Column(
                    children: [
                      Container(
                        width: sliderIndicatorWidth,
                        height: sliderIndicatorWidth,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(blurRadius: 7, color: AppColors.shadow)],
                          color: AppColors.white,
                        ),
                        child: Image.asset(
                          'assets/images/delivery_courier_icon.png',
                          width: 35,
                          height: 40,
                        ),
                      ),
                      CustomPaint(
                        size: Size(15.0, 10.0),
                        painter: TrianglePainter(isDown: true, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 218,
                    margin: EdgeInsets.symmetric(horizontal: screenGutter),
                    padding: EdgeInsets.symmetric(horizontal: screenGutter),
                    width: infoContainerWidth,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      boxShadow: [BoxShadow(blurRadius: 7, color: AppColors.shadow)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Slider(
                              value: sliderValue,
                              onChanged: (newValue) {
                                setState(() {
                                  sliderValue = newValue;
                                });
                              },
                              divisions: sliderDivisions,
                              min: 1,
                              max: 4,
                            ),
                            Row(
                              children: List.generate(
                                _stepsText.length,
                                (i) => Expanded(
                                  child: Text(
                                    Translations.of(context).get(_stepsText[i]),
                                    style: AppTextStyles.subtitleXs,
                                    textAlign: i == 0
                                        ? TextAlign.start
                                        : i == _stepsText.length - 1
                                            ? TextAlign.end
                                            : TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [BoxShadow(blurRadius: 7, color: AppColors.shadow)],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: AppIcon.iconMdPrimary(FontAwesomeIcons.solidUser),
                                    height: 55.0,
                                    width: 55.0,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(color: AppColors.shadow, blurRadius: 4),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Lara')
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.solidComments,
                                        color: AppColors.white,
                                        size: 14,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.solidFileAlt,
                                        color: AppColors.white,
                                        size: 14,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getOffset(double screenWidth) {
    double sliderDivisionWidth = (screenWidth - (screenGutter * 4) - (sliderSideGutter * 2)) / sliderDivisions;
    return ((sliderValue - 1) * sliderDivisionWidth) + (screenGutter * 2) - (sliderIndicatorWidth / 2) + sliderSideGutter;
  }
}

class TrianglePainter extends CustomPainter {
  bool isDown;
  Color color;

  TrianglePainter({this.isDown = true, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint();
    _paint.strokeWidth = 2.0;
    _paint.color = color;
    _paint.style = PaintingStyle.fill;

    Path path = new Path();
    if (isDown) {
      path.moveTo(0.0, -1.0);
      path.lineTo(size.width, -1.0);
      path.lineTo(size.width / 2.0, size.height);
    } else {
      path.moveTo(size.width / 2.0, 0.0);
      path.lineTo(0.0, size.height + 1);
      path.lineTo(size.width, size.height + 1);
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/triangle_painter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class TrackOrderInfoContainer extends StatefulWidget {
  @override
  _TrackOrderInfoContainerState createState() => _TrackOrderInfoContainerState();
}

class _TrackOrderInfoContainerState extends State<TrackOrderInfoContainer> {
  double sliderValue = 1;
  double leftPosition = 30;
  int sliderDivisions = 3;
  double screenGutter = 17.0;
  double sliderIndicatorWidth = 55.0;
  double sliderIndicatorHeight = 65.0;
  double sliderSideGutter = 20;

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

    return Consumer<AppProvider>(
      builder: (c, appProvider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              left: appProvider.isRTL ? 0 : getOffset(screenSize.width),
              right: appProvider.isRTL ? getOffset(screenSize.width) : 0,
              bottom: 5,
            ),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenGutter),
            padding: EdgeInsets.symmetric(horizontal: screenGutter, vertical: 20),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  margin: EdgeInsets.only(top: 40, bottom: 10),
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
                ),
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

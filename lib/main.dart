import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/providers/AppProvider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppProvider(),
        ),
        // ...providers,
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TipTop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primary,
          accentColor: AppColors.secondary,
          scaffoldBackgroundColor: AppColors.secondaryDark,
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.fromHeight(55),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        home: LanguageSelectPage(),
      ),
    );
  }
}

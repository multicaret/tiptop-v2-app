import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  // Locale
  List<Map<String, String>> appLanguages = [
    {
      'title': 'English',
      'locale': 'en',
      'flag': 'assets/images/en-flag.png',
    },
    {
      'title': 'العربية',
      'locale': 'ar',
      'flag': 'assets/images/ar-flag.png',
    },
    {
      'title': 'كوردي',
      'locale': 'ku',
      'flag': 'assets/images/ku-flag.png',
    },
  ];
}
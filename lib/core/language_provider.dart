import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _languageCode = 'id'; // Default: Bahasa Indonesia

  String get languageCode => _languageCode;
  bool get isIndonesian => _languageCode == 'id';
  bool get isEnglish => _languageCode == 'en';

  /// Load saved language preference
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('app_language') ?? 'id';
    notifyListeners();
  }

  /// Toggle between 'id' and 'en'
  Future<void> toggleLanguage() async {
    _languageCode = _languageCode == 'id' ? 'en' : 'id';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', _languageCode);
    notifyListeners();
  }

  /// Set a specific language
  Future<void> setLanguage(String code) async {
    if (code != 'id' && code != 'en') return;
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', _languageCode);
    notifyListeners();
  }
}

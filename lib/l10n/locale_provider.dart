import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LanguageMode { system, user }

class LocaleProvider extends ChangeNotifier {
  bool _isUserLocaleInit = false;
  Locale _currentLocale = Locale(Platform.localeName.split('_')[0]);
  LanguageMode _currentLanguageMode = LanguageMode.system;
  final Locale _systemLocale = Locale(Platform.localeName.split('_')[0]);

  LocaleProvider({LanguageMode? defaultLanguageMode}) {
    _loadLocale(defaultLanguageMode);
  }

  void _loadLocale(LanguageMode? defaultLanguageMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? prefsLanguageMode = prefs.getInt('language_mode');

    if (defaultLanguageMode != null && prefsLanguageMode == null) {
      await prefs.setInt('language_mode', defaultLanguageMode.index);
      _currentLanguageMode = languageMode;
    } else if (prefsLanguageMode != null) {
      _currentLanguageMode = LanguageMode.values[prefsLanguageMode];
    } else {
      _currentLanguageMode = LanguageMode.system;
    }

    _setLocaleFromCurrentLanguageMode();
    notifyListeners();
  }

  void _setLocaleFromCurrentLanguageMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (_currentLanguageMode) {
      case LanguageMode.user:
        String? prefsLanguageCode = prefs.getString('locale_languageCode');
        if (prefsLanguageCode != null) {
          _isUserLocaleInit = true;
          _currentLocale =
              Locale(prefsLanguageCode, prefs.getString('locale_countryCode'));
        } else {
          _currentLocale = _systemLocale;
        }
        break;
      case LanguageMode.system:
      default:
        _currentLocale = _systemLocale;
        break;
    }
  }

  Future<void> changeLanguageMode(LanguageMode languageMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('language_mode', languageMode.index);
    _currentLanguageMode = languageMode;

    if (languageMode == LanguageMode.system) {
      _currentLocale = _systemLocale;
    }

    notifyListeners();
  }

  Future<void> changeAppLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('locale_languageCode', locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString('locale_countryCode', locale.countryCode!);
    }

    _isUserLocaleInit = true;
    _currentLocale = Locale(locale.languageCode, locale.countryCode);

    notifyListeners();
  }

  /// Check locale has been manually set by user at least once.
  /// NOT included default one and language mode system.
  get isUserLocaleInit => _isUserLocaleInit;

  get languageMode => _currentLanguageMode;

  get locale => _currentLocale;
}

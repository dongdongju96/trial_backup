import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  LocaleService(this._preferences);

  static const String _languageCodeKey = 'selected_language_code';

  final SharedPreferences _preferences;

  // SharedPreferences stores the manual language choice on the device.
  // If nothing was saved, the app falls back to the device locale.
  Locale? loadSavedLocale() {
    final languageCode = _preferences.getString(_languageCodeKey);
    if (languageCode == null) {
      return null;
    }
    return Locale(languageCode);
  }

  // Only the language code is stored because this app supports en and ko.
  Future<void> saveLocale(Locale locale) async {
    await _preferences.setString(_languageCodeKey, locale.languageCode);
  }
}

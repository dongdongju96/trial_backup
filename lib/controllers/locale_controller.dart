import 'package:flutter/material.dart';

import '../services/locale_service.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({
    required LocaleService localeService,
    required Locale? initialLocale,
  }) : _localeService = localeService,
       _locale = initialLocale;

  final LocaleService _localeService;
  Locale? _locale;

  /// Null means Flutter should follow the device language.
  Locale? get locale => _locale;

  // Called by the language selection screen. MaterialApp listens to this
  // controller and rebuilds with the new AppLocalizations values.
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _localeService.saveLocale(locale);
    notifyListeners();
  }
}

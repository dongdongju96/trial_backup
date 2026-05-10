import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'controllers/locale_controller.dart';
import 'services/locale_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final localeService = LocaleService(preferences);
  final localeController = LocaleController(
    localeService: localeService,
    initialLocale: localeService.loadSavedLocale(),
  );

  runApp(EyeLockChallengeApp(localeController: localeController));
}

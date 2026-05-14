import 'package:eye_lock_challenge/controllers/locale_controller.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';
import 'package:eye_lock_challenge/models/game_mode.dart';
import 'package:eye_lock_challenge/models/game_result.dart';
import 'package:eye_lock_challenge/screens/game_screen.dart';
import 'package:eye_lock_challenge/screens/language_selection_screen.dart';
import 'package:eye_lock_challenge/screens/mode_selection_screen.dart';
import 'package:eye_lock_challenge/screens/permission_screen.dart';
import 'package:eye_lock_challenge/screens/result_screen.dart';
import 'package:eye_lock_challenge/screens/splash_screen.dart';
import 'package:eye_lock_challenge/services/locale_service.dart';
import 'package:eye_lock_challenge/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final localeController = LocaleController(
    localeService: LocaleService(preferences),
    initialLocale: const Locale('ko'),
  );

  runApp(_ScreenshotApp(localeController: localeController));
}

class _ScreenshotApp extends StatelessWidget {
  const _ScreenshotApp({required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final screen = Uri.base.queryParameters['screen'] ?? 'splash';

    return MaterialApp(
      locale: const Locale('ko'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _screenFor(screen),
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) => const ModeSelectionScreen(),
        );
      },
    );
  }

  Widget _screenFor(String screen) {
    switch (screen) {
      case 'mode':
        return const ModeSelectionScreen();
      case 'permission':
        return const PermissionScreen(mode: GameMode.female);
      case 'language':
        return LanguageSelectionScreen(localeController: localeController);
      case 'game':
        return const GameScreen(mode: GameMode.female);
      case 'result':
        return ResultScreen(
          result: GameResult(
            mode: GameMode.female,
            duration: const Duration(seconds: 8, milliseconds: 240),
            playedAt: DateTime(2026, 5, 14),
          ),
        );
      case 'splash':
      default:
        return const SplashScreen();
    }
  }
}

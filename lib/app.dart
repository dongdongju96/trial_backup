import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/locale_controller.dart';
import 'models/game_mode.dart';
import 'models/game_result.dart';
import 'screens/game_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/mode_selection_screen.dart';
import 'screens/permission_screen.dart';
import 'screens/result_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

class EyeLockChallengeApp extends StatelessWidget {
  const EyeLockChallengeApp({required this.localeController, super.key});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder rebuilds MaterialApp when the user manually changes
    // language. Flutter then reloads the matching ARB translations.
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale?.languageCode == 'ko') {
              return const Locale('ko');
            }
            return const Locale('en');
          },
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialRoute: SplashScreen.routeName,
          onGenerateRoute: (settings) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) {
                switch (settings.name) {
                  case SplashScreen.routeName:
                    return const SplashScreen();
                  case ModeSelectionScreen.routeName:
                    return const ModeSelectionScreen();
                  case LanguageSelectionScreen.routeName:
                    return LanguageSelectionScreen(
                      localeController: localeController,
                    );
                  case PermissionScreen.routeName:
                    return PermissionScreen(
                      mode: settings.arguments! as GameMode,
                    );
                  case GameScreen.routeName:
                    return GameScreen(mode: settings.arguments! as GameMode);
                  case ResultScreen.routeName:
                    return ResultScreen(
                      result: settings.arguments! as GameResult,
                    );
                  default:
                    return const SplashScreen();
                }
              },
            );
          },
        );
      },
    );
  }
}

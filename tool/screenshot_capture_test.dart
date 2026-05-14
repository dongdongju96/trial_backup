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
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _surfaceSize = Size(390, 844);
const _permissionChannel = MethodChannel(
  'flutter.baseflow.com/permissions/methods',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_permissionChannel, (call) async {
          if (call.method == 'checkPermissionStatus') {
            return 0;
          }
          if (call.method == 'requestPermissions') {
            return <int, int>{1: 1};
          }
          return null;
        });
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_permissionChannel, null);
  });

  testWidgets('capture all app screens', (tester) async {
    await tester.binding.setSurfaceSize(_surfaceSize);
    tester.view.devicePixelRatio = 1;
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      tester.view.resetDevicePixelRatio();
    });

    for (final locale in const [Locale('ko'), Locale('en')]) {
      final language = locale.languageCode;

      await _capture(
        tester,
        locale: locale,
        name: '${language}_splash',
        child: const SplashScreen(),
      );
      await _capture(
        tester,
        locale: locale,
        name: '${language}_mode_selection',
        child: const ModeSelectionScreen(),
      );
      await _capture(
        tester,
        locale: locale,
        name: '${language}_language_selection',
        child: LanguageSelectionScreen(
          localeController: await _localeController(locale),
        ),
      );

      for (final mode in GameMode.values) {
        final modeName = mode.name;

        await _capture(
          tester,
          locale: locale,
          name: '${language}_${modeName}_permission',
          child: PermissionScreen(mode: mode),
          pumpDuration: const Duration(milliseconds: 500),
        );
        await _capture(
          tester,
          locale: locale,
          name: '${language}_${modeName}_game',
          child: GameScreen(mode: mode),
          pumpDuration: const Duration(milliseconds: 500),
        );
        await _capture(
          tester,
          locale: locale,
          name: '${language}_${modeName}_result',
          child: ResultScreen(
            result: GameResult(
              mode: mode,
              duration: const Duration(seconds: 8, milliseconds: 240),
              playedAt: DateTime(2026, 5, 14),
            ),
          ),
        );
      }
    }
  });
}

Future<LocaleController> _localeController(Locale locale) async {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  return LocaleController(
    localeService: LocaleService(preferences),
    initialLocale: locale,
  );
}

Future<void> _capture(
  WidgetTester tester, {
  required Locale locale,
  required String name,
  required Widget child,
  Duration? pumpDuration,
}) async {
  final boundaryKey = ValueKey<String>('screenshot-$name');

  await tester.pumpWidget(
    RepaintBoundary(
      key: boundaryKey,
      child: MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: child,
        onGenerateRoute: (_) {
          return MaterialPageRoute<void>(
            builder: (_) => const ModeSelectionScreen(),
          );
        },
      ),
    ),
  );

  if (pumpDuration != null) {
    await tester.pump(pumpDuration);
  } else {
    await tester.pump();
  }

  await expectLater(
    find.byKey(boundaryKey),
    matchesGoldenFile('../screenshots/generated/$name.png'),
  );
}

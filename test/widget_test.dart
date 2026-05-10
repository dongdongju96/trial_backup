import 'package:eye_lock_challenge/app.dart';
import 'package:eye_lock_challenge/controllers/locale_controller.dart';
import 'package:eye_lock_challenge/services/locale_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Splash screen shows app name', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeService = LocaleService(preferences);

    await tester.pumpWidget(
      EyeLockChallengeApp(
        localeController: LocaleController(
          localeService: localeService,
          initialLocale: const Locale('en'),
        ),
      ),
    );

    expect(find.text('Eye Lock Challenge'), findsOneWidget);
    expect(find.byIcon(Icons.remove_red_eye_outlined), findsOneWidget);
  });
}

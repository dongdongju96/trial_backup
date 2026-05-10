import 'dart:async';

import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../utils/constants.dart';
import 'mode_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(ModeSelectionScreen.routeName);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.remove_red_eye_outlined,
              size: 76,
              color: AppColors.cyanAccent,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              localizations.appTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.splashTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(localizations.splashTagline, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}

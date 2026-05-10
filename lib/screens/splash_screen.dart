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
    _timer = Timer(const Duration(milliseconds: 1200), () {
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
              color: AppConstants.accentColor,
            ),
            const SizedBox(height: 24),
            Text(
              localizations.appTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localizations.splashTagline,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

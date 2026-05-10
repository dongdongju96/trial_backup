import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../models/game_result.dart';
import '../widgets/primary_button.dart';
import 'game_screen.dart';
import 'mode_selection_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({required this.result, super.key});

  static const String routeName = '/result';

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.flag_outlined, size: 68, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                localizations.gameOver,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                localizations.resultDurationIntro,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Text(
                localizations.resultDurationSeconds(result.formattedSeconds),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                label: localizations.retry,
                icon: Icons.refresh,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    GameScreen.routeName,
                    arguments: result.mode,
                  );
                },
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: localizations.backToModeSelection,
                icon: Icons.grid_view_rounded,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    ModeSelectionScreen.routeName,
                    (route) => false,
                  );
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
